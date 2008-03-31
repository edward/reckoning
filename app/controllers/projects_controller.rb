class ProjectsController < ApplicationController
  def index
    @days = (0..5).map {|i| Date.today - i.days - 2.days}.reverse
  end
end
