class CreateActiveAdminComments < ActiveRecord::Migration
  def change
    create_table :active_admin_comments do |t|
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
  end
end
