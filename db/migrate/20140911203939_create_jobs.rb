class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer  "solution_id",                    null: false
      t.datetime "start_on",                       null: false
      t.string   "time",           default: "",    null: false
      t.string   "name",           default: "",    null: false
      t.datetime "finished_on",                    null: false
      t.string   "purchase_order", default: "",    null: false
      t.boolean  "active",         default: false, null: false
      t.boolean  "complete",       default: false, null: false
      t.datetime "created_at",                     null: false
      t.datetime "updated_at",                     null: false
    end
  end
end
