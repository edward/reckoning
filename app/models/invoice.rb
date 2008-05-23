class Invoice < ActiveRecord::Base
  has_many :tasks
  belongs_to :client
  
  alias_attribute :sent_on, :sent_at
  alias_attribute :paid_on, :paid_at
  
  # # Generate a new invoice number if none is currently associated
  # def number_with_default
  #   if number_without_default.nil?
  #     self.number = generate_new_number
  #   else
  #     number_without_default
  #   end
  # end
  # alias_method_chain :number, :default
  
  protected
    def generate_new_number
      # TODO - should generate a unique new number based off of user settings
      # See ticket #7
      id
    end
end
