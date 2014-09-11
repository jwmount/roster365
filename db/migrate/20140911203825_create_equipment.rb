class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.string   "name",       default: "", null: false
      t.integer  "company_id",              null: false
      t.datetime "created_at",              null: false
      t.datetime "updated_at",              null: false
    end
  end
end
