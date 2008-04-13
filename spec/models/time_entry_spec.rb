require File.dirname(__FILE__) + '/../spec_helper'

describe TimeEntry do
  before(:each) do
    @task = mock_model(Task)
    @te = TimeEntry.new(:start_time => Time.now, :task => @task)
  end

  it "should be valid" do
    @te.should be_valid
  end
  
  it "should validate presence of a task" do
    @te.task = nil
    @te.should_not be_valid
  end
  
  it "should have notes" do
    @te.should respond_to(:notes)
  end
  
  it "should have after_notes" do
    @te.should respond_to(:after_notes)
  end
  
  it "should have a start time" do
    @te.should respond_to(:start_time)
  end
  
  it "should have an end time" do
    @te.should respond_to(:end_time)
  end
  
  it "should belong to a task" do
    @te.should respond_to(:task_id)
  end
  
  it "should require a starting time on save" do
    @te.start = nil
    @te.should_not be_valid
  end
  
  it "should calculate total time" do
    start_time = Time.now
    end_time = Time.now + 5.minutes
    
    @te.should_receive(:end_time).at_least(:once).and_return(end_time)
    @te.should_receive(:start_time).at_least(:once).and_return(start_time)
    @te.total_time.should == end_time - start_time
  end
  
end
