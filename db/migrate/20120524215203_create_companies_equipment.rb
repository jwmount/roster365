class CreateCompaniesEquipment < ActiveRecord::Migration
  def change
# Removed because HABTM changed to HM-BT
#    create_table :companies_equipment, :id=>false do |t|
#      t.integer :company_id
#      t.integer :equipment_id
#    end
  end
  
  def self.down
    drop_table :companies_equipment
  end
  
end
