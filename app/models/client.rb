class Client < ActiveRecord::Base
  has_many :projects
  
  validates_uniqueness_of :name
  validates_numericality_of :default_rate
  
  def to_s
    name
  end
end
