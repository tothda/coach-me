class AddBasicColumnsToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :title, :string
  end
end
