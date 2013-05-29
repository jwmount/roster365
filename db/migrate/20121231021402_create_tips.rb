class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.string  :name
      t.integer :company_id
      t.decimal :fee
      t.integer :fire_ant_risk_level
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tips
  end  
end
