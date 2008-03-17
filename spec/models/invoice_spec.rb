require File.dirname(__FILE__) + '/../spec_helper'

describe Invoice do
  before(:each) do
    @invoice = Invoice.new
  end

  it "should be valid" do
    @invoice.should be_valid
  end
  
  describe "when sent" do
    it "should freeze attached tasks because they've been sent out"
  end
  
  # Invalidation is for the "ohcrap" moment, when something's already been sent out, but there's an error
  describe "when invalidated and already sent" do
    it "should do a deep copy on its associated belongs_tos (tasks, taxes, etc.) and mark those copies without an associated invoice"
  end
end
