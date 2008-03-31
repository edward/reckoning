class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :invoice
  has_many :time_entries do
    def for(date)
      find(:all, :conditions => ['start_time >= ? and start_time < ?', date, date + 1.day])
    end
  end
  
  def total_time
    time_entries.inject(0) {|sum, te| sum += te.total_time}
  end
  
  def total_time_for(date)
    time_entries.for(date).sum {|te| te.total_time}
  end
  
  def name_identifier
    name.scan(/(#\d+)/).flatten.first
  end
end
