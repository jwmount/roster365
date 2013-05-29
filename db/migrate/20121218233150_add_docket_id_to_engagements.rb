# Mistake, engagements has_many dockets, does not take docket_id!
class AddDocketIdToEngagements < ActiveRecord::Migration
  def change
    add_column :engagements, :docket_id, :integer
  end
  def down
    remove_column :engagements, :docket_id, :integer
  end
end
