class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.boolean  "approved",                                                 default: false,    null: false
      t.boolean  "client_approved",                                          default: false,    null: false
      t.integer  "drive_time_from_load_to_tip",                              default: 0,        null: false
      t.integer  "drive_time_into_site",                                     default: 0,        null: false
      t.integer  "drive_time_into_tip",                                      default: 0,        null: false
      t.integer  "drive_time_out_of_site",                                   default: 0,        null: false
      t.integer  "drive_time_out_of_tip_site",                               default: 0,        null: false
      t.integer  "drive_time_tip_to_load",                                   default: 0,        null: false
      t.string   "equipment_name",                                           default: "",       null: false
      t.decimal  "equipment_dollars_per_day",        precision: 7, scale: 2, default: 0.0,      null: false
      t.integer  "equipment_units_required_per_day",                         default: 1,        null: false
      t.decimal  "hourly_hire_rate",                 precision: 7, scale: 2, default: 0.0,      null: false
      t.decimal  "invoice_load_client",              precision: 7, scale: 2, default: 0.0,      null: false
      t.decimal  "invoice_tip_client",               precision: 7, scale: 2, default: 0.0,      null: false
      t.integer  "kms_one_way",                                              default: 1,        null: false
      t.integer  "load_time",                                                default: 1,        null: false
      t.integer  "loads_per_day",                                            default: 1,        null: false
      t.integer  "material_id",                                                                 null: false
      t.string   "name",                                                     default: "",       null: false
      t.decimal  "pay_equipment_per_unit",           precision: 7, scale: 2, default: 0.0,      null: false
      t.decimal  "pay_load_client",                  precision: 7, scale: 2, default: 0.0,      null: false
      t.decimal  "pay_tip_client",                   precision: 7, scale: 2, default: 0.0,      null: false
      t.decimal  "pay_tip",                          precision: 7, scale: 2, default: 0.0,      null: false
      t.decimal  "pay_tolls",                        precision: 7, scale: 2, default: 0.0,      null: false
      t.boolean  "purchase_order_required",                                  default: false,    null: false
      t.integer  "quote_id",                                                                    null: false
      t.string   "solution_type",                                            default: "Export", null: false
      t.boolean  "semis_permitted",                                          default: false,    null: false
      t.integer  "total_material",                                           default: 1,        null: false
      t.string   "unit_of_material",                                         default: "m3",     null: false
      t.integer  "unload_time",                                              default: 1,        null: false
      t.datetime "created_at",                                                                  null: false
      t.datetime "updated_at",                                                                  null: false
    end
  end
end
