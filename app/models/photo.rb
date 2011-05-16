class Photo < ActiveRecord::Base

  belongs_to :category

  validates_presence_of :filename, :category_id

  def deactivate
    if self.status.eql?('active')
      self.status = 'inactive'
      self.save(false)
    else
      raise "#{self.class} object has already been deleted"
    end
  end
end
