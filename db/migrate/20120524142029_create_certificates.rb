class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.string :name
      t.string :description
      t.boolean :for_contact
      t.boolean :for_company
      t.boolean :for_equipment
      t.boolean :active

      t.timestamps
    end
  end
end
