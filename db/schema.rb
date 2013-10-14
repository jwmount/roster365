# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130212041557) do

  create_table "RolesUsers", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.integer "id",      null: false
  end

  create_table "active_admin_comments", force: true do |t|
    t.string   "resource_id",                                   null: false
    t.string   "resource_type",                                 null: false
    t.integer  "author_id",                                     null: false
    t.string   "author_type",   default: "",                    null: false
    t.text     "body",          default: "",                    null: false
    t.datetime "created_at",    default: '2013-10-08 00:00:00', null: false
    t.datetime "updated_at",    default: '2013-10-08 00:00:00', null: false
    t.string   "namespace",     default: "admin",               null: false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "street_address",   default: "",                    null: false
    t.string   "city",             default: "",                    null: false
    t.string   "state",            default: "",                    null: false
    t.string   "post_code",        default: "",                    null: false
    t.string   "map_reference",    default: "",                    null: false
    t.datetime "created_at",       default: '2013-10-08 00:00:00', null: false
    t.datetime "updated_at",       default: '2013-10-08 00:00:00', null: false
  end

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version"
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree

  create_table "certificates", force: true do |t|
    t.string   "name",          default: "",                    null: false
    t.string   "description",   default: "",                    null: false
    t.boolean  "for_person",    default: false,                 null: false
    t.boolean  "for_company",   default: false,                 null: false
    t.boolean  "for_equipment", default: false,                 null: false
    t.boolean  "for_location",  default: false,                 null: false
    t.boolean  "active",        default: false,                 null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "certs", force: true do |t|
    t.integer  "certifiable_id",                                   null: false
    t.string   "certifiable_type",                                 null: false
    t.integer  "certificate_id",                                   null: false
    t.datetime "expires_on",                                       null: false
    t.string   "serial_number",    default: "",                    null: false
    t.boolean  "permanent",        default: false,                 null: false
    t.boolean  "active",           default: false,                 null: false
  end

  create_table "companies", force: true do |t|
    t.string   "name",         default: "",                    null: false
    t.integer  "credit_terms", default: 30,                    null: false
    t.boolean  "PO_required",  default: false,                 null: false
    t.boolean  "active",       default: false,                 null: false
    t.string   "MYOB_number",  default: "00000",               null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "conditions", force: true do |t|
    t.string   "name",               default: "",                    null: false
    t.text     "verbiage",           default: "",                    null: false
    t.string   "indication",         default: "",                    null: false
    t.boolean  "status",             default: false,                 null: false
    t.boolean  "approved",           default: false,                 null: false
    t.string   "change_approved_by", default: "",                    null: false
    t.datetime "change_approved_at",                                 null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "dockets", force: true do |t|
    t.integer  "engagement_id",                                                            null: false
    t.integer  "person_id",                                                                null: false
    t.string   "booking_no",                               default: "",                    null: false
    t.datetime "date_worked",                                                              null: false
    t.datetime "dated",                                                                    null: false
    t.datetime "received_on",                                                              null: false
    t.boolean  "operator_signed",                          default: false,                 null: false
    t.boolean  "client_signed",                            default: false,                 null: false
    t.boolean  "approved",                                 default: false,                 null: false
    t.datetime "approved_on",                                                              null: false
    t.decimal  "a_inv_pay",        precision: 7, scale: 2, default: 0.0,                   null: false
    t.decimal  "b_inv_pay",        precision: 7, scale: 2, default: 0.0,                   null: false
    t.decimal  "supplier_inv_pay", precision: 7, scale: 2, default: 0.0,                   null: false
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
  end

  create_table "engagements", force: true do |t|
    t.integer  "schedule_id",                                          null: false
    t.integer  "person_id",                                            null: false
    t.integer  "docket_id",                                            null: true  
    t.boolean  "onsite_now",           default: false,                 null: false
    t.boolean  "onsite_at",            default: false,                 null: false
    t.boolean  "breakdown",            default: false,                 null: false
    t.boolean  "no_show",              default: false,                 null: false
    t.boolean  "OK_tomorrow",          default: false,                 null: false
    t.boolean  "engagement_declined",  default: false,                 null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "equipment", force: true do |t|
    t.string   "name",       default: "",                           null: false
    t.integer  "company_id",                                        null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "identifiers", force: true do |t|
    t.integer  "identifiable_id",                                   null: false
    t.string   "identifiable_type",                                 null: false
    t.string   "name",              default: "",                    null: false
    t.string   "value",             default: "",                    null: false
    t.integer  "rank",              default: 1,                     null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "jobs", force: true do |t|
    t.integer  "solution_id",                                    null: false
    t.datetime "start_on",                                       null: false
    t.string   "time",           default: "",                    null: false
    t.string   "name",           default: "",                    null: false
    t.datetime "finished_on",                                    null: false
    t.string   "purchase_order", default: "",                    null: false
    t.boolean  "active",         default: false,                 null: false
    t.boolean  "complete",       default: false,                 null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "materials", force: true do |t|
    t.string   "name",        default: "",                      null: false
    t.string   "description", default: "",                      null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "people", force: true do |t|
    t.integer  "company_id",                                    null: false
    t.string   "first_name",    default: "",                    null: false
    t.string   "last_name",     default: "",                    null: false
    t.string   "title",         default: "",                    null: false
    t.boolean  "available",     default: true,                  null: false
    t.datetime "available_on",                                  null: false
    t.boolean  "OK_to_contact", default: true,                  null: false
    t.boolean  "active",        default: true,                  null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "people_schedules", id: false, force: true do |t|
    t.integer "person_id",   null: false
    t.integer "schedule_id", null: false
  end

  create_table "projects", force: true do |t|
    t.string   "name",             default: "",                    null: false
    t.integer  "company_id",                                       null: false
    t.integer  "rep_id",                                           null: false
    t.datetime "project_start_on",                                 null: false
    t.boolean  "active",           default: true,                  null: false
    t.boolean  "intend_to_bid",    default: false,                 null: false
    t.boolean  "submitted_bid",    default: false,                 null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "quotes", force: true do |t|
    t.integer  "project_id",                                            null: false
    t.integer  "quote_to_id",                                           null: false
    t.integer  "rep_id",                                                null: false
    t.string   "name",                  default: "",                    null: false
    t.boolean  "fire_ants",             default: false,                 null: false
    t.string   "fire_ants_verified_by", default: "",                    null: false
    t.text     "inclusions",            default: "",                    null: false
    t.datetime "expected_start",                                        null: false
    t.integer  "duration",              default: 1,                     null: false
    t.string   "council",               default: "",                    null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  create_table "requirements", force: true do |t|
    t.integer  "requireable_id"
    t.string   "requireable_type"
    t.integer  "certificate_id"
    t.string   "description"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "schedules", force: true do |t|
    t.datetime "day"
    t.integer  "job_id"
    t.integer  "equipment_id"
    t.integer  "equipment_units_today"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "solutions", force: true do |t|
    t.boolean  "approved",                                                 default: false,                 null: false
    t.boolean  "client_approved",                                          default: false,                 null: false
    t.integer  "drive_time_from_load_to_tip",                              default: 0,                     null: false
    t.integer  "drive_time_into_site",                                     default: 0,                     null: false
    t.integer  "drive_time_into_tip",                                      default: 0,                     null: false
    t.integer  "drive_time_out_of_site",                                   default: 0,                     null: false
    t.integer  "drive_time_out_of_tip_site",                               default: 0,                     null: false
    t.integer  "drive_time_tip_to_load",                                   default: 0,                     null: false
    t.decimal  "equipment_dollars_per_day",        precision: 7, scale: 2, default: 0.0,                   null: false
    t.integer  "equipment_id",                                                                             null: false
    t.integer  "equipment_units_required_per_day",                         default: 1,                     null: false
    t.decimal  "hourly_hire_rate",                 precision: 7, scale: 2, default: 0.0,                   null: false
    t.decimal  "invoice_load_client",              precision: 7, scale: 2, default: 0.0,                   null: false
    t.decimal  "invoice_tip_client",               precision: 7, scale: 2, default: 0.0,                   null: false
    t.integer  "kms_one_way",                                              default: 1,                     null: false
    t.integer  "load_time",                                                default: 1,                     null: false
    t.integer  "loads_per_day",                                            default: 1,                     null: false
    t.integer  "material_id",                                                                              null: false
    t.string   "name",                                                     default: "",                    null: false
    t.decimal  "pay_equipment_per_unit",           precision: 7, scale: 2, default: 0.0,                   null: false
    t.decimal  "pay_load_client",                  precision: 7, scale: 2, default: 0.0,                   null: false
    t.decimal  "pay_tip_client",                   precision: 7, scale: 2, default: 0.0,                   null: false
    t.decimal  "pay_tip",                          precision: 7, scale: 2, default: 0.0,                   null: false
    t.decimal  "pay_tolls",                        precision: 7, scale: 2, default: 0.0,                   null: false
    t.boolean  "purchase_order_required",                                  default: false,                 null: false
    t.integer  "quote_id",                                                                                 null: false
    t.string   "solution_type",                                            default: "Export",              null: false
    t.boolean  "semis_permitted",                                          default: false,                 null: false
    t.integer  "total_material",                                           default: 1,                     null: false
    t.string   "unit_of_material",                                         default: "m3",                  null: false
    t.integer  "unload_time",                                              default: 1,                     null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "solutions_tips", id: false, force: true do |t|
    t.integer "solution_id", null: false
    t.integer "tip_id",      null: false
  end

  create_table "tips", force: true do |t|
    t.string   "name",                                        default: "",                    null: false
    t.integer  "company_id",                                                                  null: false
    t.decimal  "fee",                 precision: 7, scale: 2, default: 0.0,                   null: false
    t.integer  "fire_ant_risk_level",                         default: 1,                     null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

end
