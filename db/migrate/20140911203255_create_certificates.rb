class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.string   "name",          default: "",    null: false
      t.string   "description",   default: "",    null: false
      t.boolean  "for_person",    default: false, null: false
      t.boolean  "for_company",   default: false, null: false
      t.boolean  "for_equipment", default: false, null: false
      t.boolean  "for_location",  default: false, null: false
      t.boolean  "active",        default: false, null: false
      t.datetime "created_at",                    null: false
      t.datetime "updated_at",                    null: false
    end
  end
end
