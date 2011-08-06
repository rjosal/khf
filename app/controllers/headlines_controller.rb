class HeadlinesController < ApplicationController

  before_filter :login_required

  # POST /headlines
  # POST /headlines.xml
  def create
    headline = Headline.new(params[:headline])
    headline.status = 'active'

    respond_to do |format|
      if headline.save
        flash[:notice] = 'Headline was successfully created.'
        format.html { redirect_to '/?section=headlines' }

        # send email to any users that should get it
        unless params[:email_users].nil?
          User.emailable.each do |user|
            Mailer.deliver_new_headline_notification( user, headline )
            Rails.logger.info "Sent new headline email to #{user.email}"
          end
          flash[:notice] += "<br> Enqueued #{User.emailable.size} notification emails to registered members."
        end
      else
        flash[:warning] = headline.errors.full_messages.collect{|e| e+'<br>'}
        format.html { redirect_to '/?section=headlines' }
      end
    end
  end

  # PUT /headlines/1
  # PUT /headlines/1.xml
  def update
    headline = Headline.find(params[:id])

    respond_to do |format|
      if headline.update_attributes(params[:headline])
        flash[:notice] = 'Headline was successfully updated.'
        format.html { redirect_to '/?section=headlines' }
      else
        flash[:warning] = headline.errors.full_messages.collect{|e| e+'<br>'}
        format.html { redirect_to '/?section=headlines' }
      end
    end
  end

  # DELETE /headlines/1
  # DELETE /headlines/1.xml
  def destroy
    headline = Headline.find(params[:id])
    headline.deactivate

    respond_to do |format|
      format.html { redirect_to '/?section=headlines' }
    end
  end
end
