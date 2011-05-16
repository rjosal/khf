class Link < ActiveRecord::Base

  validates_as_uri :href
  validates_presence_of :filename

  def deactivate
    if self.status.eql?('active')
      self.status = 'inactive'
      self.save(false)
    else
      raise "#{self.class} object has already been deleted"
    end
  end
end
