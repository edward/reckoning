module CoreExtensions
  module Date
    module Calculations
      def projects
        # OPTIMIZE - I should probably just drop to sql here
        # FIXME - Why doesn't :select have any effect? (Maybe a bug with has_finder ?)
        Project.find(tasks.find(:all, :select => 'project_id').map(&:project_id).uniq)
      end

      def tasks
        Task.for(self)
      end
      
      def time_entries
        TimeEntry.for(self)
      end

      def total_time
        time_entries.inject(0) {|sum, entry| sum + entry.total_time }
      end
    end
  end
end