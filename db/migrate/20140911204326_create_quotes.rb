class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.integer  "project_id",                            null: false
      t.integer  "quote_to_id",                           null: false
      t.integer  "rep_id",                                null: false
      t.string   "name",                  default: "",    null: false
      t.boolean  "fire_ants",             default: false, null: false
      t.string   "fire_ants_verified_by", default: "",    null: false
      t.text     "inclusions",            default: "",    null: false
      t.datetime "expected_start",                        null: false
      t.integer  "duration",              default: 1,     null: false
      t.string   "council",               default: "",    null: false
      t.datetime "created_at",                            null: false
      t.datetime "updated_at",                            null: false
    end
  end
end
