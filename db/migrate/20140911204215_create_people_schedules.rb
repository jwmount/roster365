class CreatePeopleSchedules < ActiveRecord::Migration
  def change
    create_table :people_schedules do |t|
      t.integer "person_id",   null: false
      t.integer "schedule_id", null: false
    end
  end
end
