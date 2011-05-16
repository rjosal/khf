# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'khf/user_monitor'

Rails::Initializer.run do |config|
  # config.gem "mysql"
  
  # secret key for verifying cookie session data integrity.
  config.action_controller.session = {
    :session_key => '_khf_session',
    :secret      => 'kdub6539kbvzife32hohghkjtfwoifoimnuygveyhi643sduy86d4ds2ds6juk0k9iugt5vfbvjkuy53wd6h9k0l9jdytn4hj8bdt'
  }

  # 'require' some gems here so you don't have to elsewhere
  config.gem 'will_paginate'

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  config.time_zone = 'UTC'
  
  config.after_initialize do
    # validations common in several models like validates_as_email
    require 'khf/common_validations'
    # strip_all
    require 'khf/model_helpers'
    ActiveRecord::Base.send(:include, ModelHelpers)
  end
end

#use our activerecord extension for created_by/updated_by
ActiveRecord::Base.class_eval do
  include ActiveRecord::UserMonitor
end

# make rails helpers produce HTML, not XHTML.
module ActionView::Helpers::TagHelper
  def tag_with_html(name, options = nil, open = true, escape = true)
    tag_without_html(name, options, true, escape)
  end
  alias_method_chain :tag, :html
end

# email settings
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true # change to true in dev
ActionMailer::Base.default_content_type = 'text/html'
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 587,
   :enable_starttls_auto => true,
   :domain => "gmail.com",
   :authentication => :login,
   :user_name => "666khf",
   :password => "kitsaphaunted",
}
