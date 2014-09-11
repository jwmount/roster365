class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.integer  "requireable_id"
      t.string   "requireable_type"
      t.integer  "certificate_id"
      t.boolean  "for_person",       default: false, null: false
      t.boolean  "for_company",      default: false, null: false
      t.boolean  "for_equipment",    default: false, null: false
      t.boolean  "for_location",     default: false, null: false
      t.boolean  "preference",       default: false, null: false
      t.string   "description"
      t.datetime "created_at",                       null: false
      t.datetime "updated_at",                       null: false
    end
  end
end
