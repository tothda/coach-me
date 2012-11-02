class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.datetime :started_at

      t.timestamps
    end
  end
end
