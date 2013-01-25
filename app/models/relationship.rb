class Relationship < ActiveRecord::Base
  belongs_to :object, :class_name => User
  belongs_to :subject, :class_name => User
  attr_accessible :object_id, :rel, :subject_id

  CODES = ["TRAINER_OF", "VIEWER_OF"]
end
