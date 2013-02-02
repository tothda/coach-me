class TrainingSerializer < ActiveModel::Serializer
  embed :ids, :include => true
  
  attributes :id, :started_at, :title, :user_id, :feeling, :temperature, :weather, :surface, :notes
  has_many :exercises, :key => :exercises
end
