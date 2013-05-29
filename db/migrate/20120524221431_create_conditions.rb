class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.string :name
      t.text :verbiage
      t.string :indication
      t.boolean :status
      t.boolean :approved
      t.string :change_approved_by
      t.datetime :change_approved_at

      t.timestamps
    end
  end
end
