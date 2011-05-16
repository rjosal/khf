class OpenDate < ActiveRecord::Base
  
  attr_accessor :start_time_hour, :start_time_minute, :start_time_meridiem,
                :lights_on_end_time_hour, :lights_on_end_time_minute, :lights_on_end_time_meridiem,
                :end_time_hour, :end_time_minute, :end_time_meridiem,
                :date_open_month, :date_open_day, :date_open_year
  
  #should use validates_numericality_of for most of these, but it doesn't work since they aren't "real" attributes
  validates_presence_of :date_open, :message => 'must be a valid date'
  validates_format_of :start_time_hour, :with => /^(0?[1-9]|1[0-2])$/, :message => 'must be a number, 1-12'
  validates_format_of :start_time_minute, :with => /^(0?[0-9]|[1-5][0-9])$/, :message => 'must be a number, 0-59'
  validates_format_of :start_time_meridiem, :with => /AM|PM/
  validates_format_of :lights_on_end_time_hour, :with => /^(0?[1-9]|1[0-2])$/, :message => 'must be a number, 1-12'
  validates_format_of :lights_on_end_time_minute, :with => /^(0?[0-9]|[1-5][0-9])$/, :message => 'must be a number, 0-59'
  validates_format_of :lights_on_end_time_meridiem, :with => /AM|PM/
  validates_format_of :end_time_hour, :with => /^(0?[1-9]|1[0-2])$/, :message => 'must be a number, 1-12'
  validates_format_of :end_time_minute, :with => /^(0?[0-9]|[1-5][0-9])$/, :message => 'must be a number, 0-59'
  validates_format_of :end_time_meridiem, :with => /AM|PM/
  validates_as_uri :purchase_link, :allow_nil => true, :allow_blank => true
  
  #validate that end time is after start time TODO

  def before_validation
    #auto fill blanks with 00
    [:start_time_minute, :lights_on_end_time_minute, :end_time_minute].each do |mins|
      self.send(mins.to_s+'=', '00') if self.send(mins).nil? or self.send(mins).empty? or self.send(mins) == 'mm'
    end
    
    #need to validate date as a whole (ie february 30th should not validate)
    year = self.date_open_year.length == 2 ? '20' + self.date_open_year : self.date_open_year
    self.date_open = Date.new(year.to_i, self.date_open_month.to_i, self.date_open_day.to_i) rescue self.date_open = nil
  end
  
  def after_validation
    #doing this post-validation gives us finer grained error messages
    #convert to UTC
    if self.start_time_meridiem == 'AM' && self.start_time_hour != '12' || (self.start_time_hour == '12' && self.start_time_meridiem == 'PM')
      sth = self.start_time_hour
    else
      if self.start_time_hour != '12'
        sth = (self.start_time_hour.to_i + 12).to_s
      else
        sth = '00' # 12:xx AM goes here
      end
    end
    if self.lights_on_end_time_meridiem == 'AM' && self.lights_on_end_time_hour != '12' ||
          (self.lights_on_end_time_hour == '12' && self.lights_on_end_time_meridiem == 'PM')
      lo_eth = self.lights_on_end_time_hour
    else
      if self.lights_on_end_time_hour != '12'
        lo_eth = (self.lights_on_end_time_hour.to_i + 12).to_s
      else
        lo_eth = '00' # 12:xx AM goes here
      end
    end
    if self.end_time_meridiem == 'AM' && self.end_time_hour != '12' || (self.end_time_hour == '12' && self.end_time_meridiem == 'PM')
      eth = self.end_time_hour
    else
      if self.end_time_hour != '12'
        eth = (self.end_time_hour.to_i + 12).to_s
      else
        eth = '00' # 12:xx AM goes here
      end
    end
    #get times ready for db insertion
    self.start_time = sth+':'+self.start_time_minute+':00'
    self.lights_on_end_time = lo_eth+':'+self.lights_on_end_time_minute+':00'
    self.end_time = eth+':'+self.end_time_minute+':00'
  end

  def deactivate
    if self.status.eql?('active')
      self.status = 'inactive'
      self.save(false)
    else
      raise "#{self.class} object has already been deleted"
    end
  end
end
