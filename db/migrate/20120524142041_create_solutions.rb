class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :quote_id
      t.integer :vendor_id
      t.string :name
      t.integer :material_id
      t.integer :kms_one_way
      t.string :unit_of_material
      t.integer :total_material
      t.string :solution_type
      t.boolean :semis_permitted
      t.integer :equipment_id
      t.boolean :T360_approved
      t.boolean :client_approved
      t.decimal :equipment_dollars_per_day
      t.integer :drive_time_into_site
      t.integer :load_time
      t.integer :drive_time_out_of_site
      t.integer :drive_time_from_load_to_tip
      t.integer :drive_time_tip_to_load
      t.integer :drive_time_into_tip
      t.integer :unload_time
      t.integer :drive_time_out_of_tip_site
      t.integer :loads_per_day
      t.decimal :inv_client_1
      t.decimal :inv_client_2
      t.decimal :pay_equipment_per_unit
      t.decimal :pay_tolls
      t.decimal :pay_tip
      t.integer :equipment_units_required_per_day
      t.boolean :purchase_order_required
      t.timestamps
    end
  end
  
  def self.down
    drop_table :solutions
  end

end
