class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.integer :requireable_id
      t.string  :requireable_type
      t.integer :certificate_id
      t.string  :description
      t.timestamps
    end
  end
  
  def self.down
    drop_table :requirements
  end
  
end
