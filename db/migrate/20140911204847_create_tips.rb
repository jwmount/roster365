class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.string   "name",                                        default: "",  null: false
      t.integer  "company_id",                                                null: false
      t.decimal  "fee",                 precision: 7, scale: 2, default: 0.0, null: false
      t.string   "fire_ant_risk_level",                         default: "",  null: false
      t.datetime "created_at",                                                null: false
      t.datetime "updated_at",                                                null: false
    end
  end
end
