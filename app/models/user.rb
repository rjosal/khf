class User < ActiveRecord::Base
  # validations
  validates_presence_of :name, :role, :hashed_password
  validates_uniqueness_of :email, :scope => :status, :if => Proc.new{|user| user.status = 'active'}
  validates_as_email :email
  validates_length_of :email, :maximum => 255

  attr_protected :last_login #can only be written explicitly

  def self.emailable
    User.find(:all, :conditions => {:status => 'active', :email_status => 'good'})
  end

  def before_validation
    strip_all :name, :email
  end
  
  # method to set hashed password
  def password=(password)    
    self.salt = User.random_string( 10 ) if self.salt.nil?
    self.hashed_password = User.encrypt( password, self.salt )
  end
  
  # for active scaffold
  def password
    ''
  end

  # authenticate based on password and email
  # only grant access to active users
  def self.authenticate (email, password)
    return nil if email.nil? || password.nil? || email == '' || password == ''
    user = find_by_email(email, :conditions => {:status => 'active'})
    return nil if user.nil?
    if user.hashed_password == User.encrypt( password, user.salt )
      if user.status == 'active'
        return user
      end
    end
    nil
  end
  
  private
  
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt)
  end
  
  # used for salt
  def self.random_string(length)
    str = ""
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    1.upto(length) { |i| str << chars[rand(chars.size-1)] }
    str
  end
end
