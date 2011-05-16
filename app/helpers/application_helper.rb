# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def flash_helper
    flash_keys = [:notice, :warning, :message]
    flash_message = ''
    for key in flash_keys
      if flash[key]
        color = key == :warning ? 'red' : 'blue'
        heading = key == :warning ? 'Error:' : 'Message:'
        flash_message = flash_message + "<div id=\"flash\" style=\"border: 1px dashed #{color};\">#{heading} #{flash[key]}</div>"
      end
      flash[key] = nil;
    end
    flash_message
  end
end
