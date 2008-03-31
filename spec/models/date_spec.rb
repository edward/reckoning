require File.dirname(__FILE__) + '/../spec_helper'

# Note that the Date model does not exist; this is spec-ing core-extensions to the Date class
# defined in lib/core_extensions/date/calculations.rb

describe Date do
  before(:each) do
    @date = Date.today
  end

  describe "#tasks" do
    it "should fetch tasks with time entries for that date" do
      time_entries_proxy = mock("time entries proxy")
      time_entries_proxy.should_receive(:map).and_return(time_entries_proxy)
      time_entries_proxy.should_receive(:uniq).and_return(time_entries_proxy)
      time_entries_proxy.should_receive(:empty?).and_return(false)

      TimeEntry.should_receive(:find).with(:all, :conditions => ['start_time >= ? and start_time < ?', @date, @date + 1.day]).
                and_return(time_entries_proxy)
      Task.should_receive(:find).with(time_entries_proxy)

      @date.tasks
    end
  end
  
  describe "#project" do
    it "should fetch all projects with tasks with time entries for that date" do
      tasks_proxy = mock("tasks proxy")
      project_ids = mock("project_ids")

      tasks_proxy.should_receive(:empty?).and_return(false)
      tasks_proxy.should_receive(:map).and_return(project_ids) # FIXME - how do I specify the block here?
      project_ids.should_receive(:uniq).and_return(project_ids)

      @date.should respond_to(:projects)
      @date.should_receive(:tasks).at_least(:once).and_return(tasks_proxy)

      Project.should_receive(:find).with(project_ids)

      @date.projects
    end
  end
  
  describe "#time_entries" do
    it "should return all time entries that started on that day" do
      TimeEntry.should_receive(:find).with(:all, {:conditions => ["start_time >= ? and start_time < ?", @date, @date + 1.day]})
      @date.time_entries
    end
  end
  
  describe "#total_time" do
    it "should sum all time entries' time for that date" do
      tasks_proxy = mock("tasks proxy")
      @date.should_receive(:tasks).and_return(tasks_proxy)
      tasks_proxy.should_receive(:sum)
      @date.total_time
    end
  end
end
