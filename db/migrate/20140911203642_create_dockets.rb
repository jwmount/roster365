class CreateDockets < ActiveRecord::Migration
  def change
    create_table :dockets do |t|
      t.integer  "engagement_id",                                            null: false
      t.integer  "person_id",                                                null: false
      t.string   "number",                                   default: "",    null: false
      t.datetime "date_worked",                                              null: false
      t.datetime "dated",                                                    null: false
      t.datetime "received_on",                                              null: false
      t.boolean  "operator_signed",                          default: false, null: false
      t.boolean  "client_signed",                            default: false, null: false
      t.boolean  "approved",                                 default: false, null: false
      t.datetime "approved_on",                                              null: false
      t.string   "approved_by",                              default: "",    null: false
      t.decimal  "a_inv_pay",        precision: 7, scale: 2, default: 0.0,   null: false
      t.decimal  "b_inv_pay",        precision: 7, scale: 2, default: 0.0,   null: false
      t.decimal  "supplier_inv_pay", precision: 7, scale: 2, default: 0.0,   null: false
      t.datetime "created_at",                                               null: false
      t.datetime "updated_at",                                               null: false
    end
  end
end
