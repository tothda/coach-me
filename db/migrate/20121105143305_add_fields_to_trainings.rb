class AddFieldsToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :feeling, :string
    add_column :trainings, :temperature, :string
    add_column :trainings, :weather, :string
    add_column :trainings, :surface, :string
    add_column :trainings, :notes, :text
  end
end
