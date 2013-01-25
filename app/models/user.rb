class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :trainings

  has_many :trainer_associations, :class_name => 'Relationship', :foreign_key => 'subject_id', :conditions => "rel = 'TRAINER_OF'"
  has_many :trainers, :through => :trainer_associations, :source => :object

  has_many :trainees_associations, :class_name => 'Relationship', :foreign_key => 'object_id', :conditions => "rel = 'TRAINER_OF'"
  has_many :trainees, :through => :trainees_associations, :source => :subject

  has_many :viewer_associations, :class_name => 'Relationship', :foreign_key => 'subject_id', :conditions => "rel = 'VIEWER_OF'"
  has_many :viewers, :through => :viewer_associations, :source => :object

  has_many :viewed_athlete_associations, :class_name => 'Relationship', :foreign_key => 'object_id', :conditions => "rel = 'VIEWER_OF'"
  has_many :viewed_athletes, :through => :viewed_athlete_associations, :source => :subject
  
  def admin?
    role == "ADMIN"
  end

  def trainer_of?(subject)
    self.trainees.include? subject
  end

  def viewer_of?(subject)
    self.viewed_athletes.include? subject
  end
end
