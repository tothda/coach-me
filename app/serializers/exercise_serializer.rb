class ExerciseSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :distance, :time, :position
  has_one :training
end
