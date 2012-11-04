class Training < ActiveRecord::Base
  has_many :exercises
  attr_accessible :started_at, :title
end
