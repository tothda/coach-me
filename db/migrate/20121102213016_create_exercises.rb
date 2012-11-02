class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :name
      t.integer :position
      t.decimal :distance
      t.integer :time
      t.integer :training_id

      t.timestamps
    end
  end
end
