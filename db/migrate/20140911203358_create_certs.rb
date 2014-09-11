class CreateCerts < ActiveRecord::Migration
  def change
    create_table :certs do |t|
      t.integer  "certifiable_id",                   null: false
      t.string   "certifiable_type",                 null: false
      t.integer  "certificate_id",                   null: false
      t.datetime "expires_on",                       null: false
      t.string   "serial_number",    default: "",    null: false
      t.boolean  "permanent",        default: false, null: false
      t.boolean  "active",           default: false, null: false
    end
  end
end
