class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :invoice
  has_many :time_entries

  has_finder :for, lambda { |date|
    {:include => :time_entries,
     :conditions => ['time_entries.start_time >= ? and time_entries.start_time < ?', date, date + 1.day]}
  }
  
  alias_attribute :entries, :time_entries
  
  def total_time
    time_entries.inject(0) {|sum, te| sum + te.total_time}
  end
  
  def total_time_for(date)
    time_entries.for(date).inject(0) {|sum, te| sum + te.total_time}
  end
  
  def name_identifier
    name.scan(/(#\d+)/).flatten.first
  end
end
