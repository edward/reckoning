class TimeEntry < ActiveRecord::Base
  belongs_to :task
  
  alias_attribute(:start, :start_time)
  alias_attribute(:end, :end_time)
  alias_attribute(:stop, :end_time)
  
  validates_presence_of :start_time
  validates_presence_of :task
  
  def total_time
    result = end_time - start_time
    
    # This feels a little iffy, but when you have
    # 
    #   Sat Mar 29 19:59:36 EDT 2008
    #     Start: 07:59PM    Reckoning: #1 projects/index body -> show report of last week's work
    #     End:   01:00AM
    # 
    # it's the right thing to do
    result += 1.day if result < 0
    
    return result
  end
  alias_method(:length, :total_time)
  alias_method(:size, :total_time)
  
  # protected
  # 
  #   def validate
  #     if end_time && start_time
  #       result = end_time - start_time
  #       errors.add([:start_time, :end_time], "Temporal anomaly; start time takes place after end time") if result < 0
  #     end
  #   end
end
