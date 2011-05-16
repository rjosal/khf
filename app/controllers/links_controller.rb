class LinksController < ApplicationController
  layout 'khf_no_tabs'

  # GET /links
  # GET /links.xml
  def index
    @title = 'Links to other Haunted Houses, Insane Asylums, and Gory Scary Places'
    @links = Link.find(:all, :conditions => {:status => 'active'})
    # Log an event
    Event.create :name => 'PageView', :description => request.url,
                 :referer => request.headers['referer'], :ip => request.remote_ip

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @links }
    end
  end

  # GET /links/new
  # GET /links/new.xml
  def new
    @link = Link.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /links
  # POST /links.xml
  def create
    @link = Link.new(params[:link])
    result = create_image(params[:file], Rails.root.join("public/images/links/"))
    if result[:errors].blank?
      @link.filename = result[:filename_on_disk]
    else
      flash[:errors] = result[:errors].join "; "
    end

    respond_to do |format|
      if @link.save
        flash[:notice] = 'Link was successfully created.'
        format.html { redirect_to(links_path) }
        format.xml  { render :xml => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.xml
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        flash[:notice] = 'Link was successfully updated.'
        format.html { redirect_to(links_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.xml
  def destroy
    @link = Link.find(params[:id])
    @link.deactivate

    respond_to do |format|
      format.html { redirect_to(links_url) }
      format.xml  { head :ok }
    end
  end
end
