class TrainingSerializer < ActiveModel::Serializer
  attributes :id, :started_at, :title, :user_id, :feeling, :temperature, :weather, :surface, :notes
end
