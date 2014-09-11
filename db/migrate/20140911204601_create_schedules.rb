class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.datetime "day",                               null: false
      t.integer  "job_id",                            null: false
      t.integer  "equipment_units_today", default: 0, null: false
      t.datetime "created_at",                        null: false
      t.datetime "updated_at",                        null: false
    end
  end
end
