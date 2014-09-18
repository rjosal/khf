class CommentsController < ApplicationController

  before_filter :login_required

  # POST /comments
  # POST /comments.xml
  def create
    comment = Comment.new(params[:comment])
    comment.headline_id = params[:headline_id]
    comment.status = 'active'

    respond_to do |format|
      if comment.save
        flash[:notice] = 'comment was successfully created.'
        format.html { redirect_to '/?section=headlines&year='+comment.headline.created_at.year.to_s }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:warning] = comment.errors.full_messages.collect{|e| e+'<br>'}
        format.html { redirect_to '/?section=headlines' }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    comment = Comment.find(params[:id])

    respond_to do |format|
      if comment.update_attributes(params[:comment])
        flash[:notice] = 'comment was successfully updated.'
        format.html { redirect_to '/?section=headlines' }
        format.xml  { head :ok }
      else
        flash[:warning] = comment.errors.full_messages.collect{|e| e+'<br>'}
        format.html { redirect_to '/?section=headlines' }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    comment = Comment.find(params[:id])
    comment.deactivate

    respond_to do |format|
      format.html { redirect_to '/?section=headlines' }
      format.xml  { head :ok }
    end
  end
end
