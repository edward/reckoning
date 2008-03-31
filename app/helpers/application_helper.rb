# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # OPTIMIZE - extend Numeric instead
  def seconds_in_hours_and_minutes(seconds)
    hours = (seconds / 3600).floor
    minutes = ((seconds % 3600) / 60).floor
    "#{hours}:#{sprintf("%02d", minutes)}"
  end
  
  def seconds_in_fractions_of_hours(seconds)
    hours_fraction = (seconds / 3600 * 100).round / 100.0
  end
end
