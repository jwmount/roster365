class CreateEngagements < ActiveRecord::Migration
  def change
    create_table :engagements do |t|
      t.integer :schedule_id
      t.integer :contact_id
      t.integer :booking_no
      t.boolean :onsite_now
      t.boolean :onsite_at
      t.boolean :breakdown
      t.boolean :no_show
      t.boolean :OK_tomorrow
      t.boolean :engagement_declined
      t.datetime :next_available_day
      t.datetime :do_not_contact_until
      t.datetime :contacted_at
      t.datetime :date_next_available

      t.timestamps
    end
  end
  
  def self.down
    drop_table :engagements
  end
  
end
