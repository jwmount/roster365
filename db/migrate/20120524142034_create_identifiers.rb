class CreateIdentifiers < ActiveRecord::Migration
  def change
    create_table :identifiers do |t|
      t.integer :identifiable_id
      t.string :identifiable_type
      t.string :name
      t.string :value
      t.integer :rank

      t.timestamps
    end
  end
  
  def self.down
    drop_table :identifiers
  end

end
