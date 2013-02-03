class TrainingSerializer < ActiveModel::Serializer
  embed :ids, :include => true
  
  attributes :id, :started_at, :title, :user_id, :feeling, :temperature, :weather, :surface, :notes, :permission
  has_many :exercises, :key => :exercises
  
  def permission
    ability = Ability.new(scope)
    if ability.can? :manage_trainings, scope
      "rw"
    elsif ability.can? :read_trainings, scope
      "r"
    end
  end
end
