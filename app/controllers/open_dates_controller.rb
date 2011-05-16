class OpenDatesController < ApplicationController

  before_filter :login_required

  def create
    open_date = OpenDate.new(params[:open_date])
    open_date.status = 'active'
    respond_to do |format|
      if open_date.save
        flash[:notice] = 'Open date was successfully created.'
        format.html { redirect_to '/?section=hours' }
      else
        flash[:warning] = open_date.errors.full_messages.collect{|e| e+'<br>'}
        format.html { redirect_to '/?section=hours' }
      end
    end
  end

  def update
    open_date = OpenDate.find(params[:id])

    respond_to do |format|
      # NOTE: update_attribute does not do validation (update_attributes does)
      if open_date.update_attribute(:purchase_link, params[:open_date][:purchase_link])
        flash[:notice] = 'Open date was successfully updated.'
        format.html { redirect_to '/?section=hours' }
      else
        flash[:warning] = open_date.errors.full_messages.collect{|e| e+'<br>'}
        format.html { redirect_to '/?section=hours' }
      end
    end
  end

  def destroy
    open_date = OpenDate.find(params[:id])
    open_date.deactivate

    respond_to do |format|
      format.html { redirect_to '/?section=hours' }
    end
  end
end
