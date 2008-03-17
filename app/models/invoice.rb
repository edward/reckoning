class Invoice < ActiveRecord::Base
  has_many :tasks
  belongs_to :client
  
  alias_attribute :sent_on, :sent_at
  alias_attribute :paid_on, :paid_at
  
end
