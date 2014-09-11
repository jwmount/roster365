class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer  "company_id",                   null: false
      t.string   "first_name",    default: "",   null: false
      t.string   "last_name",     default: "",   null: false
      t.string   "title",         default: "",   null: false
      t.boolean  "available",     default: true, null: false
      t.datetime "available_on",                 null: false
      t.boolean  "OK_to_contact", default: true, null: false
      t.boolean  "active",        default: true, null: false
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
    end
  end
end
