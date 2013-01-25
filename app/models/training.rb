class Training < ActiveRecord::Base
  has_many :exercises, :order => "id ASC"
  belongs_to :user
  attr_accessible :started_at, :title, :feeling, :temperature, :weather, :surface, :notes

  FEELINGS = [["Awesome", "awesome"],["Good", "good"],["So-so", "soso"],["Sluggish", "sluggish"],["Injured", "injured"]]
  FEELING_VALUES =  {"awesome" => 5, "good" => 4, "soso" => 3, "sluggish" => 2, "injured" => 1}
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
end
