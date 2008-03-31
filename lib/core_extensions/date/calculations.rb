module CoreExtensions
  module Date
    module Calculations
      def projects
        unless tasks.empty?
          project_ids = tasks.map {|task| task.project_id}.uniq
          return Project.find(project_ids)
        else
          return []
        end
      end

      def tasks
        task_ids = time_entries || []
        task_ids = task_ids.map {|te| te.task_id}.uniq
        task_ids.empty? ? [] : Task.find(task_ids)
      end
      
      def time_entries
        TimeEntry.find(:all, :conditions => ['start_time >= ? and start_time < ?', self, self + 1.day])
      end

      def total_time
        time_entries.sum {|time_entry| time_entry.total_time}
      end
    end
  end
end