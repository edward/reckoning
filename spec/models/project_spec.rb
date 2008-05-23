require File.dirname(__FILE__) + '/../spec_helper'

describe Project do
  before(:each) do
    @project = Project.new(:name => "A Project Name")
  end

  it "should be valid" do
    @project.should be_valid
  end
  
  it "should have a name" do
    @project.should respond_to(:name)
  end
  
  it "should not be valid without a name" do
    @project.name = nil
    @project.should_not be_valid
  end
  
  describe "#tasks_for(date)" do
    it "should fetch all tasks with a time entry starting on that date" do
      date = Date.today
      tasks_proxy = mock("tasks proxy")
      @project.should_receive(:tasks).and_return(tasks_proxy)
      tasks_proxy.should_receive(:for).with(date).and_return(tasks_proxy)
      # tasks_proxy.should_receive(:find).with(:all, {:conditions => ["time_entries.start_time >= ? and time_entries.start_time < ?", date, date + 1.day], :include => :time_entries})
      @project.tasks.for(date)
    end
  end
  
  describe "#total_time" do
    it "should sum total time of tasks' time entries" do
      time_entries_proxy = mock("time_entries proxy")
      @project.should_receive(:time_entries).and_return(time_entries_proxy)
      # FIXME - figure out how to expect receival of a method with a block
      #       tasks.inject(0) {|sum, task| sum += task.total_time}
      time_entries_proxy.should_receive(:inject)
      @project.total_time
    end
  end
  
  describe "#total_time_for(date)" do
    it "should sum total time for a given date" do
      date = Date.today
      tasks_proxy = mock("tasks proxy")
      @project.should_receive(:tasks).and_return(tasks_proxy)
      tasks_proxy.should_receive(:for).with(date).and_return(tasks_proxy)
      tasks_proxy.should_receive(:inject).with(0)
      @project.total_time_for(date)
    end
  end
end