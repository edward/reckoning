require File.dirname(__FILE__) + '/../spec_helper'

# Note that the Date model does not exist; this is spec-ing core-extensions to the Date class
# defined in lib/core_extensions/date/calculations.rb

describe Date do
  before(:each) do
    @date = Date.today
  end

  describe "#tasks" do
    it "should fetch tasks with time entries for that date" do
      Task.should_receive(:for).with(@date)
      @date.tasks
    end
  end
  
  describe "#project" do
    it "should fetch all projects with tasks with time entries for that date" do
      tasks_proxy = mock("tasks proxy")
      project_ids = mock("project_ids")
      projects_proxy = mock("projects proxy")

      @date.should_receive(:tasks).at_least(:once).and_return(tasks_proxy)
      tasks_proxy.should_receive(:find).with(:all, {:select=>"project_id"}).and_return(project_ids)
      project_ids.should_receive(:map).and_return(project_ids)
      project_ids.should_receive(:uniq).and_return(project_ids)
      Project.should_receive(:find).with(project_ids).and_return(projects_proxy)

      @date.projects.should == projects_proxy
    end
  end
  
  describe "#time_entries" do
    it "should return all time entries that started on that day" do
      TimeEntry.should_receive(:for).with(@date)
      @date.time_entries
    end
  end
  
  describe "#total_time" do
    it "should sum all time entries' time for that date" do
      time_entries_proxy = mock("time entries proxy")
      @date.should_receive(:time_entries).and_return(time_entries_proxy)
      time_entries_proxy.should_receive(:inject)
      @date.total_time
    end
  end
end
