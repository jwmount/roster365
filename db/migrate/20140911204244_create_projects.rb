class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string   "name",             default: "",    null: false
      t.integer  "company_id",                       null: false
      t.integer  "rep_id",                           null: false
      t.datetime "project_start_on",                 null: false
      t.string   "description"
      t.boolean  "active",           default: true,  null: false
      t.boolean  "intend_to_bid",    default: false, null: false
      t.boolean  "submitted_bid",    default: false, null: false
      t.datetime "created_at",                       null: false
      t.datetime "updated_at",                       null: false
    end
  end
end
