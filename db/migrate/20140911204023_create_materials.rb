class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string   "name",        default: "", null: false
      t.string   "description", default: "", null: false
      t.datetime "created_at",               null: false
      t.datetime "updated_at",               null: false
    end
  end
end
