ActiveRecord::Validations::ClassMethods.class_eval do
  def validates_as_uri(*attr_names)
    configuration = {
      :message   => 'must be a valid URI',
      :with      => URI.regexp }
    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
    validates_format_of attr_names, configuration
  end
  
  def validates_as_email(*attr_names)
    configuration = {
      :message   => 'must be a valid email format',
      :with      => /\A[\w.%+-]+@([a-z0-9]+[.-])*[a-z0-9]+\.[a-z]{2,}\z/ }
    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
    validates_format_of attr_names, configuration
  end
  
  def validates_as_zip_code(*attr_names)
    configuration = {
      :message   => 'must be a valid zip code',
      :with      => /(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}$)/ }
    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
    validates_format_of attr_names, configuration
  end
end
