class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string   "name",              default: "",      null: false
      t.integer  "credit_terms",      default: 30,      null: false
      t.boolean  "PO_required",       default: false,   null: false
      t.boolean  "active",            default: true,    null: false
      t.string   "bookeeping_number", default: "00000", null: false
      t.string   "line_of_business",  default: "",      null: false
      t.string   "url",               default: "",      null: false
      t.boolean  "licensee",          default: false,   null: false
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
    end
  end
end
