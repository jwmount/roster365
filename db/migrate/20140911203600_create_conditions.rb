class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.string   "name",               default: "",    null: false
      t.text     "verbiage",           default: "",    null: false
      t.string   "indication",         default: "",    null: false
      t.boolean  "status",             default: false, null: false
      t.boolean  "approved",           default: false, null: false
      t.string   "change_approved_by", default: "",    null: false
      t.datetime "change_approved_at",                 null: false
      t.datetime "created_at",                         null: false
      t.datetime "updated_at",                         null: false
    end
  end
end
