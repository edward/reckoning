require File.dirname(__FILE__) + '/../spec_helper'

describe Task do
  before(:each) do
    @task = Task.new
  end

  it "should be valid" do
    @task.should be_valid
  end
  
  it "should belong to an invoice" do
    @task.should respond_to(:invoice_id)
  end
  
  it "should belong to a project" do
    @task.should respond_to(:project_id)
  end
  
  it "should have a name" do
    @task.should respond_to(:name)
  end
  
  it "should have a rate" do
    @task.should respond_to(:rate)
  end
  
  it "should have notes" do
    @task.should respond_to(:notes)
  end
  
  it "should have after_notes" do
    @task.should respond_to(:after_notes)
  end
  
  it "should have a time estimate" do
    @task.should respond_to(:time_estimate)
  end
  
  it "should have time entries" do
    @task.should respond_to(:time_entries)
  end
  
  it "should report the difference between the total spent time and the estimate"
  
  describe "#total_time" do
    it "should sum the time entries' total time" do
      te = mock_model(TimeEntry)
      @task.should_receive(:time_entries).and_return([te])
      te.should_receive(:total_time).and_return 0
      @task.total_time
    end
  end
  
  describe "#total_time_for(date)" do
    it "should sum the time entries' total time for a given day" do
      date = Date.today
      time_entries_mock = mock("time entries mock")
      time_entries_mock.should_receive(:for).with(date).and_return(time_entries_mock)
      time_entries_mock.should_receive(:sum)
      
      @task.should_receive(:time_entries).and_return(time_entries_mock)
      
      @task.total_time_for(date)
    end
  end
  
  describe "#name_identifier" do
    it "should return the first task name identifier seen in the name" do
      @task.should_receive(:name).and_return "#123"
      @task.name_identifier.should == "#123"
    end
  end
end
