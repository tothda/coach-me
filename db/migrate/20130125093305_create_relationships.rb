class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :subject_id
      t.integer :object_id
      t.string :rel

      t.timestamps
    end
  end
end
