class Exercise < ActiveRecord::Base
  belongs_to :training
  attr_accessible :distance, :name, :position, :hours, :minutes, :seconds, :time
  
  attr_accessor :hours, :minutes, :seconds
  before_save :update_time
  after_initialize :update_hours_minutes_seconds

  def update_time
    s = hours.to_i * 3600 + minutes.to_i * 60 + seconds.to_i
    
    # In case of 0 second, we suppose the exercise was or will not
    # be measured.
    self.time = s == 0 ? nil : s
  end
  
  def update_hours_minutes_seconds
    if time
      @hours = time / 3600
      @minutes = (time - 3600 * @hours) / 60
      @seconds = time - 3600 * @hours - 60 * @minutes
    end
  end
  
  def formatted_time
    if time
      "%2d:%02d:%02d" % [hours, minutes, seconds]
    else
      "-"
    end
  end
end
