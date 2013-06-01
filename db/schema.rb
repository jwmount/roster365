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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130212041557) do

  create_table "RolesUsers", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.integer "id",      :null => false
  end

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "addresses", :force => true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "post_code"
    t.string   "map_reference"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "audits", :force => true do |t|
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

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"

  create_table "certificates", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "for_person"
    t.boolean  "for_company"
    t.boolean  "for_equipment"
    t.boolean  "active"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "certs", :force => true do |t|
    t.integer  "certifiable_id"
    t.string   "certifiable_type"
    t.integer  "certificate_id"
    t.datetime "expires_on"
    t.string   "serial_number"
    t.boolean  "permanent"
    t.boolean  "active"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.integer  "credit_terms"
    t.boolean  "PO_required"
    t.boolean  "active"
    t.string   "MYOB_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "conditions", :force => true do |t|
    t.string   "name"
    t.text     "verbiage"
    t.string   "indication"
    t.boolean  "status"
    t.boolean  "approved"
    t.string   "change_approved_by"
    t.datetime "change_approved_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "xcontacts", :force => true do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.boolean  "available"
    t.datetime "next_available_on"
    t.boolean  "OK_to_contact"
    t.boolean  "active",            :default => true
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  # Are we using this?
  create_table "people_schedules", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "schedule_id"
  end

  create_table "dockets", :force => true do |t|
    t.integer  "engagement_id"
    t.integer  "person_id"
    t.string   "booking_no"
    t.datetime "date_worked"
    t.datetime "dated"
    t.datetime "received_on"
    t.boolean  "operator_signed"
    t.boolean  "client_signed"
    t.boolean  "T360_approved"
    t.integer  "T360_approved_by"
    t.datetime "T360_approved_on"
    t.boolean  "T360_2nd_approval"
    t.integer  "T360_2nd_approval_by"
    t.datetime "T360_2nd_approval_on"
    t.decimal  "a_inv_pay",            :precision => 7, :scale => 2
    t.decimal  "b_inv_pay",            :precision => 7, :scale => 2
    t.decimal  "supplier_inv_pay",     :precision => 7, :scale => 2
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  create_table "engagements", :force => true do |t|
    t.integer  "schedule_id"
    t.integer  "person_id"
    t.boolean  "onsite_now"
    t.boolean  "onsite_at"
    t.boolean  "breakdown"
    t.boolean  "no_show"
    t.boolean  "OK_tomorrow"
    t.boolean  "engagement_declined"
    t.datetime "next_available_day"
    t.datetime "do_not_contact_until"
    t.datetime "contacted_at"
    t.datetime "date_next_available"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "docket_id"
  end

  create_table "equipment", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "identifiers", :force => true do |t|
    t.integer  "identifiable_id"
    t.string   "identifiable_type"
    t.string   "name"
    t.string   "value"
    t.integer  "rank"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "jobs", :force => true do |t|
    t.integer  "solution_id"
    t.datetime "start_on"
    t.string   "time"
    t.string   "name"
    t.datetime "finished_on"
    t.string   "purchase_order"
    t.boolean  "active"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.boolean  "complete"
  end

  create_table "materials", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "people", :force => true do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.boolean  "available"
    t.datetime "available_on"
    t.boolean  "OK_to_contact"
    t.boolean  "active"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.integer  "rep_id"
    t.datetime "project_start_on"
    t.boolean  "active"
    t.boolean  "intend_to_bid"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "quotes", :force => true do |t|
    t.integer  "project_id"
    t.integer  "quote_to_id"
    t.integer  "rep_id"
    t.string   "name"
    t.boolean  "fire_ants"
    t.string   "fire_ants_verified_by"
    t.integer  "em_coordinator_id"
    t.text     "inclusions"
    t.datetime "expected_start"
    t.integer  "duration"
    t.string   "council"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "requirements", :force => true do |t|
    t.integer  "requireable_id"
    t.string   "requireable_type"
    t.integer  "certificate_id"
    t.string   "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schedules", :force => true do |t|
    t.datetime "day"
    t.integer  "job_id"
    t.integer  "equipment_id"
    t.integer  "equipment_units_today"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "solutions", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "vendor_id"
    t.string   "name"
    t.integer  "material_id"
    t.integer  "kms_one_way"
    t.string   "unit_of_material"
    t.integer  "total_material"
    t.string   "solution_type"
    t.boolean  "semis_permitted"
    t.integer  "equipment_id"
    t.boolean  "approved"
    t.boolean  "client_approved"
    t.decimal  "equipment_dollars_per_day"
    t.integer  "drive_time_into_site"
    t.integer  "load_time"
    t.integer  "drive_time_out_of_site"
    t.integer  "drive_time_from_load_to_tip"
    t.integer  "drive_time_tip_to_load"
    t.integer  "drive_time_into_tip"
    t.integer  "unload_time"
    t.integer  "drive_time_out_of_tip_site"
    t.integer  "loads_per_day"
    t.decimal  "pay_equipment_per_unit"
    t.decimal  "pay_tolls"
    t.decimal  "pay_tip"
    t.integer  "equipment_units_required_per_day"
    t.boolean  "purchase_order_required"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.decimal  "pay_load_client"
    t.decimal  "invoice_load_client"
    t.decimal  "pay_tip_client"
    t.decimal  "invoice_tip_client"
    t.decimal  "hourly_hire_rate"
  end

  create_table "solutions_tips", :id => false, :force => true do |t|
    t.integer "solution_id"
    t.integer "tip_id"
  end

  create_table "tips", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.decimal  "fee"
    t.integer  "fire_ant_risk_level"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

end
