class AboutsController < ApplicationController
  
  layout 'khf_no_tabs'
  
  before_filter :login_required, :except => :index

  # GET /abouts
  # GET /abouts.xml
  def index
    @title = 'About our Haunted Barns'
    @abouts = About.all
    # Log an event
    Event.create :name => 'PageView', :description => request.url, :useragent => request.headers['user-agent'],
                 :referer => request.headers['referer'], :ip => request.remote_ip

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @abouts }
    end
  end

  # GET /abouts/new
  # GET /abouts/new.xml
  def new
    @about = About.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @about }
    end
  end

  # GET /abouts/1/edit
  def edit
    @about = About.find(params[:id])
  end

  # POST /abouts
  # POST /abouts.xml
  def create
    @about = About.new(params[:about])

    respond_to do |format|
      if @about.save
        flash[:notice] = 'About was successfully created.'
        format.html { redirect_to(abouts_path) }
        format.xml  { render :xml => @about, :status => :created, :location => @about }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @about.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /abouts/1
  # PUT /abouts/1.xml
  def update
    @about = About.find(params[:id])

    respond_to do |format|
      if @about.update_attributes(params[:about])
        flash[:notice] = 'About was successfully updated.'
        format.html { redirect_to(abouts_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @about.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /abouts/1
  # DELETE /abouts/1.xml
  def destroy
    @about = About.find(params[:id])
    @about.deactivate

    respond_to do |format|
      format.html { redirect_to(abouts_url) }
      format.xml  { head :ok }
    end
  end
end
