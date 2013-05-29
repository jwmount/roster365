class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.integer :project_id
      t.integer :quote_to_id
      t.integer :contact_id
      t.string :name
      t.boolean :fire_ants
      t.string :fire_ants_verified_by
      t.integer :em_coordinator_id
      t.text :inclusions
      t.datetime :expected_start
      t.integer :duration
      t.string :council

      t.timestamps
    end
  end
  
  def self.down
    drop_table :quotes
  end
  
end
