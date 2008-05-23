class ClientsController < ApplicationController
  def index
    @clients = Client.find(:all)
  end
  
  def new
    @client = Client.new
  end
  
  def create
    @client = Client.new(params[:client])
    
    if @client.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @client = Client.find(params[:id])
  end
  
  def update
    @client = Client.find(params[:id])
    
    if @client.update_attributes(params[:client])
      redirect_to clients_url
    else
      render :action => 'edit'
    end
  end
end