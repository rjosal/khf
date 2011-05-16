class Comment < ActiveRecord::Base
  belongs_to :headline
  
  def deactivate
    if self.status.eql?('active')
      self.status = 'inactive'
      self.save(false)
    else
      raise "#{self.class} object has already been deleted"
    end
  end
end