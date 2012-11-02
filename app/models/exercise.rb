class Exercise < ActiveRecord::Base
  belongs_to :training
  attr_accessible :distance, :name, :position, :time
end
