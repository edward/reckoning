require File.join(File.dirname(__FILE__), *%w[spec_helper])
require 'time_cruncher'

describe TimeCruncher do
  before(:each) do
  end
  
  it "should be able to parse input" do
    TimeCruncher.respond_to?(:parse).should be_true
  end
  
  it "should parse three days of valid input" do
    
    input = "Mon Jan 21 07:50:55 EST 2008
      Start: 07:50AM    Something: #183 - clicking on a bubble twice causes a Javascript explosion
      End:   08:57AM
      Start: 09:10AM    Something: debugging #183 with Frank
      End:   09:34AM
      Start: 09:34AM    Something: daily call with Lisa and Frank
      End:   09:48AM
      Start: 09:48AM    Something: #183
      End:   10:07AM
      Start: 10:17AM    same
      End:   12:00PM
      Start: 01:17PM    SomeOtherProject: #83 - investigating attachment_fu test unit failure issue
      End:   01:32PM
      Start: 01:32PM    SomeOtherProject: daily check-in with Frank, Greg, Yun, Subu, and Sam
      End:   02:01PM
      Start: 02:01PM    SomeOtherProject: #83 - investigating attachment_fu test unit failure issue
      End:   03:08PM

    Tue Jan 22 09:04:40 EST 2008
      Start: 09:04AM    SomeOtherProject: #83 - implementation of basic version
      End:   09:07AM
      Start: 09:20AM    same
      End:   09:41AM
      Start: 10:00AM    same
      End:   11:37AM
      Start: 11:50AM    same
      End:   12:30PM
      Start: 12:55PM    SomeOtherProject: #83
      End:   01:01PM
      Start: 01:54PM    SomeOtherProject: #83
      End:   02:00PM
      Start: 02:37PM    same
      End:   02:43PM
      Start: 02:59PM    same
      End:   03:00PM
      Start: 03:08PM    SomeOtherProject: #83 - check s3 backend store with Frank
      End:   03:20PM
      Start: 03:50PM    same
      End:   04:51PM
      Start: 04:51PM    EdwardOG: invoicing Frank
      End:   05:16PM
      Start: 05:46PM    SomeOtherProject: #83 - merging and committing a single-file version
      End:   06:07PM
      Start: 06:20PM    Something: #135 - looking at Hiro's revision
      End:   06:28PM
      Start: 06:35PM    same
      End:   06:56PM
    
    Mon Jan 14 09:49:25 EST 2008
      Start: 09:30AM    Something: daily check-in with Lisa and Frank
      End:   10:00AM
      Start: 10:49AM    JohnSmith: upper-lowercase-preserving reverse-complement function
      End:   11:50AM
      Start: 11:50AM    CUSEC: transport chat with Mila (Western's going in a van)
      End:   12:13PM
      Start: 12:13PM    SomeOtherProject: #83 - writing monkeypatch overriding the #save for thumbnails in attachment_fu
      End:   01:32PM
      Start: 01:32PM    SomeOtherProject: daily meeting with Sam, Greg, Frank, and Yun
      End:   02:21PM
      Start: 02:21PM    SomeOtherProject: #83
      End:   02:33PM"
      
    tc = TimeCruncher.parse(input)
    tc.days.size.should == 3
    tc.days.each do |day|
      day.tasks.each do |task|
        [:start_time, :end_time, :project_name, :notes, :after_notes].each do |property|
          task.send(property).should_not be_nil
        end
      end
    end
  end

  it "should raise an exception on invalid input" do
    input = "Tue Jan 15 10:28:39 EST 2008
               Start: 11:47AM    SomeOtherProject: #83 - fixing more broken routing specs
               End:   now
               Start: 12:30PM    Something: daily call with Frank, Lisa, and Harry
               End:   01:00PM"
    lambda { TimeCruncher.parse(input) }.should raise_error
  end
end

describe TimeCruncher::Task do
  
  before(:each) do
    @task = TimeCruncher::Task.new
    @s = mock(StringScanner, :eos? => false)
    @day = mock(TimeCruncher::Day)
  end
  
  it "should know total time (the duration) of its task" do
    TimeCruncher::Task.new.respond_to?(:total_time).should be_true
  end
  
  it "should be coercible to a String" do
    TimeCruncher::Task.new.respond_to?(:to_s).should be_true
  end
  
  it "should have a start time" do
    @task.respond_to?(:start_time)
  end
  
  it "should have an end time" do
    @task.respond_to?(:end_time)
  end
  
  it "should have a project name" do
    @task.respond_to?(:project_name)
  end
  
  it "should have notes" do
    @task.respond_to?(:notes)
  end
  
  it "should be able to parse a task" do
    TimeCruncher::Task.respond_to?(:parse).should be_true
  end
  
  it "should return nil if passed StringScanner is at end of string" do
    @s.should_receive(:eos?).and_return(true)
    
    TimeCruncher::Task.parse(@s, @day).should be_nil
  end
  
  
  describe "Given a valid task block" do
    before(:each) do
      input = "Start: 12:43PM    Something: #32 - Some notes: other things
               End:   01:11PM    some after-notes"
      
      @s = StringScanner.new(input)
      @day = mock(TimeCruncher::Day, :date => Time.now)
    end
    
    it "should find a start time" do
      task = TimeCruncher::Task.parse(@s, @day)
      task.start_time.should == Time.parse('12:43PM')
    end

    it "should find an end/stop time" do
      task = TimeCruncher::Task.parse(@s, @day)
      task.end_time.should == Time.parse('01:11PM')
    end

    it "should find a project name" do
      task = TimeCruncher::Task.parse(@s, @day)
      task.project_name.should == 'Something'
    end
    
    it "should find after-notes" do
      task = TimeCruncher::Task.parse(@s, @day)
      task.after_notes.should == 'some after-notes'
    end
    
    it "should use the preceding task's project name and notes when the word after the start time is 'same'" do
      project_name = 'some project name'
      notes = 'some notes'
      tasks = [mock(TimeCruncher::Task,
                    :project_name => project_name,
                    :notes => notes)]
      @day.should_receive(:tasks).at_least(:twice).and_return(tasks)
      
      input = "Start: 12:43PM   same (some comment)
               End:   01:11PM"
      
      @s = StringScanner.new(input)
      task = TimeCruncher::Task.parse(@s, @day)
      task.project_name.should == project_name
      task.notes.should == notes
    end
  end

  describe "Given invalid input" do
    it "should do something" do
      input = "totally invalid input"
      @s = StringScanner.new(input)
      @day = mock(TimeCruncher::Day)
      lambda { task = TimeCruncher::Task.parse(@s) }.should raise_error
    end
    
    it "should raise when missing a 'Start:' token" do
      input = "NotStart: 11:47PM    SomeProject: Had good thoughts
               End:      11:48PM"
      @s = StringScanner.new(input)
      @day = mock(TimeCruncher::Day)
      lambda { task = TimeCruncher::Task.parse(@s) }.should raise_error
    end
    
    it "should raise when missing a start_time timestamp token" do
      input = "NotStart: sometime    SomeProject: Had good thoughts
               End:      11:48PM"
      @s = StringScanner.new(input)
      @day = mock(TimeCruncher::Day)
      lambda { task = TimeCruncher::Task.parse(@s) }.should raise_error
    end
    
    it "should raise when missing a 'Stop:' token" do
      input = "Start: 11:47PM    SomeProject: Had good thoughts
               NotEnd:11:48PM"
      @s = StringScanner.new(input)
      @day = mock(TimeCruncher::Day)
      lambda { task = TimeCruncher::Task.parse(@s) }.should raise_error
    end
    
    it "should raise when missing a end_time timestamp token" do
      # input = "NotStart: 11:47PM    SomeProject: Had good thoughts
      #          End:      sometime"
      input = "Start: 11:47AM    Something: #83 - fixing more broken routing specs
               End:   now
               Start: 12:30PM    Something: daily call with Frank, Lisa, and Harry
               End:   01:00PM"
      @s = StringScanner.new(input)
      @day = mock(TimeCruncher::Day)
      lambda { task = TimeCruncher::Task.parse(@s) }.should raise_error
    end

  end
end

describe TimeCruncher::Day do
  
  before(:each) do
    @s = mock(StringScanner, :eos? => false)
  end
  
  it "should be coercible to a String" do
    TimeCruncher::Day.new.respond_to?(:to_s).should be_true
  end
  
  it "should return nil if passed StringScanner is at end of string" do
    @s.should_receive(:eos?).and_return(true)
    
    TimeCruncher::Day.parse(@s).should be_nil
  end
  
  it "should raise if the StringScanner can't find a valid date at the beginning" do
    @s.should_receive(:scan).and_return('totally not a datestamp')
    
    lambda { TimeCruncher::Day.parse(@s) }.should raise_error
  end
  
  describe "Given a valid day block of two tasks" do
    before(:each) do
      input = "Sun 16 Dec 2007 12:43:53 EST
                 Start: 12:43PM    Something: #32 - Some notes
                 End:   01:11PM
                 Start: 01:50PM    same
                 End:   01:56PM"
      
      @s = StringScanner.new(input)
      @day = TimeCruncher::Day.parse(@s)
    end
    
    it "should find two tasks" do
      @day.tasks.size.should == 2
    end
    
    it "should find a date" do
      @day.date.should == 'Sun 16 Dec 2007 12:43:53 EST'
    end
  end
end