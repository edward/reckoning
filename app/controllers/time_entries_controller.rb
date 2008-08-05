class TimeEntriesController < ApplicationController
  def index
    if params[:filter_class]
      # Get whatever was filtered, turning the string into the Class
      @filtered = Kernel.const_get(params[:filter_class]).find(params[:id])
      @days = (@filtered.time_entries.find(:first, :order => 'start_time ASC').start_time.to_date .. Date.today).to_a
    else
      # TODO Grab one week since the last TimeEntry till today
      # TimeEntry.find(:first, :order => 'created_at DESC')
      @days = (0..14).map {|i| Date.today - i.days}.reverse
    end
  end
end