class CreateEngagements < ActiveRecord::Migration
  def change
    create_table :engagements do |t|
      t.integer  "schedule_id",                         null: false
      t.integer  "person_id",                           null: false
      t.integer  "docket_id"
      t.string   "docket_number",       default: "",    null: false
      t.boolean  "onsite_now",          default: false, null: false
      t.boolean  "onsite_at",           default: false, null: false
      t.boolean  "breakdown",           default: false, null: false
      t.boolean  "no_show",             default: false, null: false
      t.boolean  "OK_tomorrow",         default: false, null: false
      t.boolean  "engagement_declined", default: false, null: false
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
    end
  end
end
