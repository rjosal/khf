class Headline < ActiveRecord::Base
  has_many :comments, :conditions => {:status => 'active'}
  
  def deactivate
    self.comments.each{|c| c.deactivate}
    if self.status.eql?('active')
      self.status = 'inactive'
      self.save(false)
    else
      raise "#{self.class} object has already been deleted"
    end
  end
end