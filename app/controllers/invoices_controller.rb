class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.find(:all)
  end
  
  def new
    
  end
  
  def create
    invoice = Invoice.new(params[:invoice])
    
    if invoice.save
      redirect_to :index
    else
      redirect_to :new
    end
  end
end
