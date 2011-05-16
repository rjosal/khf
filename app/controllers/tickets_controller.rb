class TicketsController < ApplicationController

  before_filter :login_required

  def create
    ticket = Ticket.new(params[:ticket])
    ticket.status = 'active'

    respond_to do |format|
      if ticket.save
        flash[:notice] = 'Ticket was successfully created.'
        format.html { redirect_to '/?section=admission' }
      else
        flash[:warning] = ticket.errors.full_messages.collect{|e| e+'<br>'}
        format.html { redirect_to '/?section=admission' }
      end
    end
  end

  def update
    ticket = Ticket.find(params[:id])

    respond_to do |format|
      if ticket.update_attributes(params[:ticket])
        flash[:notice] = 'Ticket was successfully updated.'
        format.html { redirect_to '/?section=admission' }
      else
        flash[:warning] = ticket.errors.full_messages.collect{|e| e+'<br>'}
        format.html { redirect_to '/?section=admission' }
      end
    end
  end

  def destroy
    ticket = Ticket.find(params[:id])
    ticket.deactivate

    respond_to do |format|
      format.html { redirect_to '/?section=admission' }
    end
  end
end
