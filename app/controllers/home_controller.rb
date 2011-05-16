require 'khf/multipart'
require 'gdata'

class HomeController < ApplicationController

  layout 'khf'
  
  def index
    @year = (params[:year].nil? ? Date.today.year : params[:year].to_i )
    @title = 'Haunted House Home ' + @year.to_s
    
    headlines_per_page = 4
    @all_headlines = Headline.find(:all, :order => "created_at DESC", :conditions => {:status => 'active'})
    current_headlines = @all_headlines.select{|h| h.created_at.year == @year}
    @current_headlines_grouped = []
    current_headlines.each_slice(headlines_per_page){|slice| @current_headlines_grouped << slice}
    
    @open_dates = OpenDate.find(:all, :order => "date_open asc", :conditions => {:status => 'active'})
    @tickets = Ticket.find(:all, :order => "price asc", :conditions => {:status => 'active'})

    # Log an event
    Event.create :name => 'PageView', :description => request.url, :useragent => request.headers['user-agent'],
                 :referer => request.headers['referer'], :ip => request.remote_ip
  end

  def videos
    @title = 'Videos from Spook Central'
    youtube_client = GData::Client::YouTube.new
    all_videos = []

    #TODO cache this response
    feed = youtube_client.get('http://gdata.youtube.com/feeds/api/users/KitsapHaunt/uploads?v=2&format=5&orderby=published').to_xml
    feed.elements.each('entry') do |entry|
      vid = Video.new
      vid.title = entry.get_elements('title')[0].text
      vid.url = entry.get_elements('media:group')[0].get_elements('media:content').select{|mc| mc.attribute('yt:format').value == '5'}[0].attribute('url').value + "&rel=0&color1=0x5b2b2b&color2=0xb66b6b&border=1&fs=1"
      all_videos << vid
    end
    @videos = all_videos.paginate(:page => params[:page], :per_page => 4)

    # Log an event
    Event.create :name => 'PageView', :description => request.url, :useragent => request.headers['user-agent'],
                 :referer => request.headers['referer'], :ip => request.remote_ip
  end

  def directions
    @title = 'Directions to this House of Haunts and Terror'
    @khf_address = ''
    @main_css_class = 'directions'
    render 'directions', :layout => 'khf_no_tabs'

    # Log an event
    Event.create :name => 'PageView', :description => request.url, :useragent => request.headers['user-agent'],
                 :referer => request.headers['referer'], :ip => request.remote_ip
  end
  
  def register
    @no_loginout = true # don't display loginout div
    @title = 'Register'
    if request.post?
      log = Logger.new('/tmp/log')
      log.warn(params)
      if params[:user][:password] == params[:confirm_password]
        @user = User.new(params[:user])
        @user.role = 'normal'
        @user.status = 'active'
        if @user.save
          session[:user_id] = @user.id
          flash[:message] = "Successfully registered #{@user.name}, and logged in."
          @user.last_login = Time.now.utc
          @user.save(false)
          update_session_expiration
          # Log an event
          Event.create :name => 'Register', :description => 'Success', :useragent => request.headers['user-agent'],
                       :referer => request.headers['referer'], :ip => request.remote_ip
          redirect_to '/'
        else
          flash[:warning] = "Registration failed."
          # Log an event
          Event.create :name => 'Register', :description => "Fail",
                       :referer => request.headers['referer'], :ip => request.remote_ip,
                       :useragent => request.headers['user-agent']
        end
      else
          flash[:warning] = "Registration failed. Password and Confirm Password did not match."
          # Log an event
          Event.create :name => 'Register', :description => 'Fail: Password and Confirm Password mismatch',
                       :referer => request.headers['referer'], :ip => request.remote_ip,
                       :useragent => request.headers['user-agent']
      end
    else
      # Log an event
      Event.create :name => 'PageView', :description => request.url, :useragent => request.headers['user-agent'],
                   :referer => request.headers['referer'], :ip => request.remote_ip
      render  :layout => 'khf_no_tabs'
    end
  end
  
  # check credentials and log in
  def login
    @no_loginout = true # don't display loginout div
    @title = 'Login'
    if request.post?
      @user = User.authenticate( params[:user][:email], params[:user][:password] )
      if !@user.nil?
        session[:user_id] = @user.id
        flash[:message] = "Successfully logged in as #{@user.name}"
        @user.last_login = Time.now.utc
        @user.save(false)
        update_session_expiration
        # Log an event
        Event.create :name => 'Login', :description => 'Success', :useragent => request.headers['user-agent'],
                     :referer => request.headers['referer'], :ip => request.remote_ip
        redirect_to '/'
      else
        flash[:warning] = "Login failed. Please check the email and password."
        # Log an event
        Event.create :name => 'Login', :description => 'Fail', :useragent => request.headers['user-agent'],
                     :referer => request.headers['referer'], :ip => request.remote_ip
      end
    else
      # Log an event
      Event.create :name => 'PageView', :description => request.url, :useragent => request.headers['user-agent'],
                   :referer => request.headers['referer'], :ip => request.remote_ip
      render  :layout => 'khf_no_tabs'
    end
  end
  
  # logout; destroy cookies
  def logout
    session[:user_id] = nil
    flash[:message] = "Successfully logged out."
    # Log an event
    Event.create :name => 'Logout', :description => 'Success', :useragent => request.headers['user-agent'],
                 :referer => request.headers['referer'], :ip => request.remote_ip
    redirect_to '/'
  end

  def email_opt_out
    u = User.find(params[:id])
    u.email_status = 'opt-out'
    if u.save(false)
      flash[:message] = "You (#{u.name}) have successfully opted out of receiving future emails from us."
    else
      flash[:message] = "There was a problem updating your user status.  Please contact tech@kitsaphauntedfairgrounds.com to resolve it.  We apologize for the inconvenience."
    end
    redirect_to '/'
  end
end
