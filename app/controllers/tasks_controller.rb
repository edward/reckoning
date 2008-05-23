class TasksController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  def import
  end
  
  def process_import
    @import_errors = []
    new_tasks = []
    
    begin
      # Parse the work day text into tasks that belong to projects
      tc = TimeCruncher.parse(params['work_day_dump'])
    rescue
      raise "Whooaaa! Check yer time tracking input:\n" + $!
    end
    
    tc.days.each do |day|
      day.tasks.each do |imported_task|
        
        project = Project.find_by_name(imported_task.project_name) || Project.create(:name => imported_task.project_name)
        
        # Search for a task name identifier like '#123' in the notes
        name_identifier = imported_task.notes.scan(/(#\d+)/).flatten.first
        
        unless name_identifier.nil?
          new_task = Task.find(:all, :conditions => {:project_id => project.id}).
                       select {|task| task.name_identifier == name_identifier}.first || 
                     Task.create(:project => project, :name => imported_task.notes)
        else
          new_task = Task.create(:project => project, :name => imported_task.notes)
        end
        
        new_task.time_entries.build(:start => imported_task.start_time,
                                    :stop => imported_task.end_time,
                                    :notes => imported_task.notes,
                                    :after_notes => imported_task.after_notes)
        unless new_task.save
          @import_errors << new_task.errors
        else
          new_tasks << new_task
        end
      end
    end
    
    respond_to do |format|
      if @import_errors.empty?
        unique_projects = new_tasks.map {|task| task.project }.uniq
        
        flash[:notice] = "#{pluralize(new_tasks.size, 'Task')} were imported for #{unique_projects.map(&:name).join(', ')}" #+ 
                         # unique_jobs.map {|job| "<a href='/jobs/#{job.id}'>#{job.name}</a>" }.split(", ")
        
        format.html { redirect_to projects_url }
        format.xml  { head :created, :location => projects_url }
      else
        format.html { render :action => "import" }
        format.xml  { render :xml => @import_errors.to_xml }
      end
    end
  end
end
