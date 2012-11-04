class AddUserIdToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :user_id, :integer
  end
end
