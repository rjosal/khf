class Category < ActiveRecord::Base

  has_many :photos do
    def active
      find(:all, :conditions => {:status => 'active'})
    end
  end

  def self.all_active
    find(:all, :conditions => {:status => 'active'})
  end

  def before_validation
    self.name = self.name.titleize.gsub(/[^a-zA-Z0-9_.-]/,"_")
  end

  def deactivate
    if self.status.eql?('active')
      self.photos.active.each{|p| p.deactivate}
      self.status = 'inactive'
      self.save(false)
    else
      raise "#{self.class} object has already been deleted"
    end
  end
end
