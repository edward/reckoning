require File.dirname(__FILE__) + '/../spec_helper'

describe Tax do
  before(:each) do
    @tax = Tax.new
  end

  it "should be valid" do
    @tax.should be_valid
  end
end
