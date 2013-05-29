class RemoveBookingNoFromEngagements < ActiveRecord::Migration
  def up
    remove_column :engagements, :booking_no
  end

  def down
    add_column :engagements, :booking_no, :string
  end
end
