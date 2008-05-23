class Project < ActiveRecord::Base
  belongs_to :client
  has_many :tasks
  has_many :time_entries, :through => :tasks
  
  has_finder :for, lambda { |date|
    {:include => {:time_entries, :tasks},
     :conditions => ['time_entries.start_time >= ? and time_entries.start_time < ?', date, date + 1.day]}
  }
  
  validates_presence_of :name
  
  # OPTIMIZE - could be done in SQL, but might not be as clear
  def total_time
    time_entries.inject(0) {|sum, time_entry| sum + time_entry.total_time}
  end
  
  def total_time_for(date)
    tasks.for(date).inject(0) {|sum, task| sum + task.total_time}
  end
end
