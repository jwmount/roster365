class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :addressable_id
      t.string :addressable_type
      t.string :street_address
      t.string :city
      t.string :state
      t.string :post_code
      t.string :map_reference

      t.timestamps
    end
  end
end
