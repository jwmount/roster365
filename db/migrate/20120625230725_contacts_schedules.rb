class ContactsSchedules < ActiveRecord::Migration
  def change
    create_table :contacts_schedules, :id=>false do |t|
      t.integer :contact_id
      t.integer :schedule_id
    end
  end
  
  def self.down
    drop_table :contacts_schedules
  end
  
end
