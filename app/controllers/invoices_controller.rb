class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.find(:all)
  end
  
  def new
    @invoice = Invoice.new(:due_on => 2.weeks.from_now)
    @clients = Client.find(:all)
  end
  
  def create
    invoice = Invoice.new(params[:invoice])
    
    if invoice.save
      redirect_to :index
    else
      redirect_to :new
    end
  end
  
  def select_client
    @client = Client.find(params[:id])
    @projects = @client.projects
    
    respond_to do |format|
      format.js # select_client.rjs
    end
  end
end
