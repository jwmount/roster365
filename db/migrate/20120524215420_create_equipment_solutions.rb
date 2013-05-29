class CreateEquipmentSolutions < ActiveRecord::Migration
  def change
# Removed because HABTM changed to HM-BT via vendor choice    
#    create_table :equipment_solutions, :id=>false do |t|
#      t.integer :equipment_id
#      t.integer :solution_id
#   end
  end
  def self.down
    drop_table :equipment_solutions
  end  
end
