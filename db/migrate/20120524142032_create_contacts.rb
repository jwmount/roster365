class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :company_id
      t.string :first_name
      t.string :last_name
      t.string :title
      t.boolean :available
      t.datetime :next_available_on
      t.boolean :OK_to_contact
      t.boolean :active,        :default => true
      t.timestamps
    end
  end
  
  def self.down
    drop_table :contacts
  end

end
