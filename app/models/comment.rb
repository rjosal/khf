class Comment < ActiveRecord::Base
  belongs_to :headline

  validates_uniqueness_of :comment, :message => "with the exact same text has already been entered."
  validates_format_of :comment, :with => /\A[a-zA-Z0-9!?#\$%()\/\[\]'":;,.\s_+=-]+\Z/, :message => "contained invalid characters."
  
  def deactivate
    if self.status.eql?('active')
      self.status = 'inactive'
      self.save(false)
    else
      raise "#{self.class} object has already been deleted"
    end
  end
end
