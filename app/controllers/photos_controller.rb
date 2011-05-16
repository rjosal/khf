class PhotosController < ApplicationController

  layout 'khf'
  
  before_filter :login_required, :except => [:index, :gallery]

  def index
    @title = 'Photos from the Haunted Freak Show'
    conds = {'photos.status' => 'active'}
    if @user and @user.role != 'normal'
    else
      if params[:category].nil?
        params[:category] = '2007'
      end
    end
    conds['categories.name'] = params[:category] unless params[:category].nil?
    @photos = Photo.find(:all, :joins => :category, :conditions => conds)

    # Log an event
    Event.create :name => 'PageView', :description => request.url, :useragent => request.headers['user-agent'],
                 :referer => request.headers['referer'], :ip => request.remote_ip
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photos }
    end
  end

  def new
    @title = 'Create New Photo'
    @photo = Photo.new

    respond_to do |format|
      format.html {render :layout => 'khf_no_tabs'} # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  def gallery
    @photos = Photo.find(:all, :joins => :category, :conditions => {'photos.status' => 'active', 'categories.name' => params[:category]})
    respond_to do |format|
      format.xml # gallery.xml.builder
    end
  end

  def create
    @photo = Photo.new(params[:photo])
    result = create_image(params[:file], Rails.root.join("public/images/photos/category_#{@photo.category.id}/"))
    if result[:errors].blank?
      @photo.filename = result[:filename_on_disk]
      @photo.status = 'active'
    else
      flash[:errors] = result[:errors].join "; "
    end

    respond_to do |format|
      if @photo.save
        flash[:notice] = 'Photo was successfully created.'
        format.html { redirect_to(photos_path) }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.deactivate

    respond_to do |format|
      format.html { redirect_to(photos_url) }
      format.xml  { head :ok }
    end
  end
end
