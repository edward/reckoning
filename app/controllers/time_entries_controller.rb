class TimeEntriesController < ApplicationController
  def index
    @days = (0..14).map {|i| Date.today - i.days}.reverse
  end
end
