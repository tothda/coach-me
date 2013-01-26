class Training < ActiveRecord::Base
  has_many :exercises, :order => "id ASC"
  belongs_to :user
  attr_accessible :started_at, :title, :feeling, :temperature, :weather, :surface, :notes

  FEELING = [["Awesome", "awesome"],["Good", "good"],["So-so", "soso"],["Sluggish", "sluggish"],["Injured", "injured"]]
  FEELING_VALUES =  {"awesome" => 5, "good" => 4, "soso" => 3, "sluggish" => 2, "injured" => 1}

  TEMPERATURE = [["Hot", "hot"],["Warm", "warm"],["Mild", "mild"],["Cold", "cold"],["Freezing", "freezing"]]

  WEATHER = [["Normal", "normal"], ["Rainy", "rainy"],["Cloudy", "cloudy"],["Sunny", "sunny"],["Snowy", "snowy"]]

  SURFACE = [["Road", "road"],["Trial", "trial"],["Offroad", "offroad"],["Mixed", "mixed"],["Beach", "beach"]]
  
  def total_distance
    exercises.map(&:distance).map(&:to_f).sum
  end

  # if it has notes or at least one exercise
  def needs_summary?
    notes.present? || exercises.present?
  end

  def feeling_value
    FEELING_VALUES[feeling] || 0
  end

  def description_of(field)
    val = send(field.to_sym)
    return "-" if val.blank?
    values = self.class.const_get(field.to_s.upcase.to_sym)
    values.detect {|x| x.last == val}.first
  end

  def title
     read_attribute(:title).blank? ? "Untitled training" :  read_attribute(:title)
  end
end
