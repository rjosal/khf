class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # to autopopulate created_by and updated_by for model objects
  before_filter :set_current_user, :update_session_expiration, :except => :login
  
  # used in various places to
  # determine if a user can do something with object
  def is_authorized (object)
    if object.nil?
      flash[:warning] = 'Invalid object.'
      redirect_to '/'
    elsif false
      flash[:warning] = 'User not authorized to work with this object.'
      redirect_to '/'
    end
  end

  # used to track tab clicks, so far
  def track
    # Log an event
    params.reject{|k,v| ['action', 'controller'].include? k}.each do |event_type, event_detail|
      Event.create :name => event_type, :description => event_detail,
                   :ip => request.remote_ip, :useragent => request.headers['user-agent']
    end
    render :nothing => true
  end
  
  protected

  # base authentication filter
  def login_required
    return true if session[:user_id] && (session[:expiration] && (session[:expiration] - Time.now).to_i > 0)
    if session[:expiration]
      flash[:warning] = 'Your session has expired. Please log in again.'
      session[:expiration] = nil
    else
      flash[:message] = 'You need to login first.'
    end
    redirect_to :controller => 'home', :action => 'login'
  end
  
  def create_image(image, path_prefix)
    result = {:errors => []}
    if image.is_a?(String)
      result[:errors] << 'No file has been chosen for upload.'
    else
      #images smaller than ~10kb get stored in a UploadedStringIO obj, not in a tempfile
      if image.is_a?(ActionController::UploadedStringIO)
        temp = ActionController::UploadedTempfile.new(image.original_filename)
        temp.binmode
        temp.write image.read
        temp.original_path = image.original_filename
        image = temp
        image.rewind
      end
      image.original_filename.gsub!(/[^a-zA-Z0-9_.-]/,'_')

      if File.exists?(path_prefix + image.original_filename)
        result[:errors] << 'An image with the same filename exists.  Please rename the image.'
      else
        #write out the image to disk
        FileUtils.mkdir_p(path_prefix) unless File.directory?(path_prefix)
        FileUtils.mv image.path, "#{path_prefix}#{image.original_filename}"
        FileUtils.chmod 0644, "#{path_prefix}#{image.original_filename}"
        if File.exists?("#{path_prefix}#{image.original_filename}")
          result[:filename_on_disk] = "#{path_prefix}#{image.original_filename}"
        else
          result[:errors] << 'A problem occurred saving the image.'
        end
      end
    end
    result
  end

  #saves users location before redirecting
  def redirect_away(*params)
    session[:original_uri] = request.request_uri
    redirect_to(*params)
  end
	
  #return to original url, or default
  def redirect_back(*params)
    uri = session[:original_uri]
    session[:original_uri] = nil
    if uri
      redirect_to uri
    else
      redirect_to(*params)
    end
  end
  
  def update_session_expiration
    session[:expiration] = 2.hours.from_now if @user
  end
  
  private

  def set_current_user
    @user = Thread.current['user'] = User.find_by_id(session[:user_id])
  end
end
