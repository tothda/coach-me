class Training < ActiveRecord::Base
  has_many :exercises
  belongs_to :user
  attr_accessible :started_at, :title, :feeling, :temperature, :weather, :surface, :notes
end
