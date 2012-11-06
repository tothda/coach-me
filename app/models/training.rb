class Training < ActiveRecord::Base
  has_many :exercises
  belongs_to :user
  attr_accessible :started_at, :title, :feeling, :temperature, :weather, :surface, :notes
  
  def total_distance
    exercises.map(&:distance).map(&:to_f).sum
  end
end
