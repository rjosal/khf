class Ticket < ActiveRecord::Base

  validates_length_of :name, :maximum => 25
  validates_as_uri :purchase_link, :allow_nil => true, :allow_blank => true

  def deactivate
    if self.status.eql?('active')
      self.status = 'inactive'
      self.save(false)
    else
      raise "#{self.class} object has already been deleted"
    end
  end
end
