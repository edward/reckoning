class Client < ActiveRecord::Base
  def to_s
    name
  end
end
