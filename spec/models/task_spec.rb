require File.dirname(__FILE__) + '/../spec_helper'

describe Task do
  before(:each) do
    @task = Task.new
  end

  it "should be valid" do
    @task.should be_valid
  end
  
end
