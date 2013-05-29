class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :company_id
      t.integer :rep_id
      t.datetime :project_start_on
      t.boolean :active
      t.boolean :T360_bid
      t.boolean :T360_won
      t.boolean :T360_intend_to_bid

      t.timestamps
    end
  end
end
