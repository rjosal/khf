# $LastChangedDate: 2009-07-29 16:57:57 -0700 (Wed, 29 Jul 2009) $
# $LastChangedBy: rjosal $

module ModelHelpers
  private
  def strip_all(*attr_names)
    attr_names.each{|attr| self.send(attr.to_s).strip! if self.send(attr.to_s)}
  end
end