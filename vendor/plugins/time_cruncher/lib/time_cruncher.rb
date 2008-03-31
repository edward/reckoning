require "strscan"
require "time"

# Edward's simple time format:
# <tt>
# [A date readable by Time.parse] (note that it doesn't support timezones as of Sat 15 Dec 2007)
# Start:\s+[time regex]\s+[project name]: [task ticket number (optional)]\s+[task notes]$
# End:\s+[a time readable by Time.parse]\s+[additional task notes]$
# </tt>
# A time regex is defined as <tt>/[1-9]?\d:\d\d(am|pm)/i</tt>
# 
# Example time format block:
# <tt>
# Sat 15 Dec 2007 17:53:27 EST
# Start: 12:43PM    Wuntoo: #32 - Non-logged in users should see a register / sign up link (partials)
# End:   01:11PM    0:30 (this worked out well)
# </tt>
# Note that to resume work on the previous task on that date, the shortcut project name "same" can be used:
# <tt>
# Sat 15 Dec 2007 17:53:27 EST
# Start: 12:43PM    Wuntoo: #32 - Non-logged in users should see a register / sign up link (partials)
# End:   01:11PM    0:30 (this worked out well) 
# Start: 01:50PM    same
# End:   01:56PM    0:05
# </tt>
# Note: if you're a night-owl your working hour past midnight (12:00 AM) are 
# attached to the date that starts the time tracking block
#
class TimeCruncher
  VERSION = '1.0.2'
  
  attr_accessor :days, :projects
  
  class Day
    attr_accessor :tasks, :date
    
    def initialize
      @tasks = []
    end
    
    # +s+ is a loaded StringScanner
    def self.parse(s)
      
      return nil if s.eos?
      
      day = Day.new
      
      # Look for a timestamp and allow for whitespace and newlines 
      # to prefix it
      # require 'rubygems'; require 'ruby-debug'; debugger
      day.date = s.scan(/.+?\w.*?$/m)
      return nil if day.date.nil?
      day.date.strip!
      
      # found in Time.parse - check if date is a parseable timestamp
      if Date._parse(day.date, false).empty?
        raise "Expected a parseable date at position #{s.pos}, before #{s.rest[0..80]}"
      end

      # Pass the day each task is part of so that we can support tasks
      # called "same" that require push-down automata functionality
      while task = Task.parse(s, day)
        day.tasks << task
      end

      return day
    end
    
    def to_s
      s = tasks.inject(date.to_s) {|total, t| total + "\n" + t.to_s }
      
      minutes = total_time / 60
      s += sprintf("\n\nTotal time: %d:%02d\n", minutes / 60, minutes % 60)
    end
    
    # Doesn't really belong in a parser; should be moved out
    def total_time
      tasks.inject(0) {|total, t| total + t.total_time }
    end
  end
    
  class Task
    attr_accessor :start_time, :end_time, :project_name, :notes, :after_notes
    
    # +s+ is a loaded StringScanner
    def self.parse(s, day)
      
      return nil if s.eos? || s.scan(/\s*Start:/).nil?
      
      task = Task.new
      
      # raise "Expected 'Start: ' at position #{s.pos}" unless s.scan(/\s*Start:/)
      # return nil unless s.scan(/\s*Start:/)
      
      timestamp_regex = /(0?|1)\d:\d\d\s*(am|pm)?/i
      task.start_time = Time.parse(day.date.to_s.gsub(/\d\d:\d\d:\d\d/,
                                                      s.scan_until(timestamp_regex)))
      
      unless task.start_time
        raise "Expected '12:12'-type timestamp at position #{s.pos}, before #{s.rest[0..80]}"
      end
      
      # consume till the end of the line if we find a 'same' token
      if s.scan_until(/^\s*same.*$/)
        if day.tasks.empty?
          raise "'same' must have a task before it on that day [position #{s.pos}, before #{s.rest[0..80]}]"
        end
        
        task.project_name = day.tasks.last.project_name
        task.notes = day.tasks.last.notes
        
      else
        # stop at the first ':' - don't be greedy
        task.project_name = s.scan(/.+?:/)
        
        unless task.project_name
          raise "Expected 'ProjectName:' at position #{s.pos}, before #{s.rest[0..80]}"
        end
        
        # Remove surrounding whitespace and the trailing ':'
        task.project_name.strip!.chop!
        
        # scan until "End: ", but don't include it in 
        # the result (zero-width lookahead)
        task.notes = s.scan_until(/.+?(?=\s*End:\s+)/m).strip
      end
      
      raise "Expected 'End: ' at position #{s.pos}, before #{s.rest[0..80]}" unless s.scan(/\s*End:/)
      
      s.scan(/\s*/) # consume any possible whitespace before the end_time timestamp
      
      temp_end_time = s.scan(timestamp_regex)
      unless temp_end_time
        raise "Expected '12:12'-type timestamp at position #{s.pos}, before #{s.rest[0..80]}"
      end
      
      task.end_time = Time.parse(day.date.to_s.gsub(/\d\d:\d\d:\d\d/, temp_end_time))
      
      # Consume till the end of the line to allow for unconsumed 'after-comments'
      task.after_notes = s.scan_until(/$/)
      task.after_notes.strip! if task.after_notes
      
      return task
    end
    
    def to_s
      if start_time && end_time && project_name && notes
        sprintf("Start: %02d:%02d    #{project_name}: #{notes}\n" +
                "End:   %02d:%02d",
                start_time.hour, start_time.min,
                end_time.hour, end_time.min)
      end
    end
    
    # Measured in seconds
    def total_time
      end_time - start_time
    end
  end
  
  def initialize
    @projects = {}
    @days = []
  end
  
  def self.parse(input)
    tc = TimeCruncher.new
    
    s = StringScanner.new(input)
    
    while day = Day.parse(s) do
      tc.days << day
    end
    
    return tc
  end
end