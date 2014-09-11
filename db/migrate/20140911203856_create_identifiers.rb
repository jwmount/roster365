class CreateIdentifiers < ActiveRecord::Migration
  def change
    create_table :identifiers do |t|
      t.integer  "identifiable_id",                null: false
      t.string   "identifiable_type",              null: false
      t.string   "name",              default: "", null: false
      t.string   "value",             default: "", null: false
      t.integer  "rank",              default: 1,  null: false
      t.datetime "created_at",                     null: false
      t.datetime "updated_at",                     null: false
    end
  end
end
