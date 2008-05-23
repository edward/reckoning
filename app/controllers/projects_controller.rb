class ProjectsController < ApplicationController
  def index
    @projects = Project.find(:all)
  end
  
  def new
    @project = Project.new
    @clients = Client.find(:all)
  end
  
  def create
    @project = Project.new(params[:project])
    
    if @project.save
      redirect_to :action => 'index'
    else
      @clients = Client.find(:all)
      render :action => 'new'
    end
  end
  
  def show
    @project = Project.find(params[:id])
  end
  
  def edit
    @project = Project.find(params[:id])
    @clients = Client.find(:all)
  end
  
  def update
    @project = Project.find(params[:id])
    
    if @project.update_attributes(params[:project])
      redirect_to :action => 'index'
    else
      @clients = Client.find(:all)
      render :action => 'edit'
    end
  end
end