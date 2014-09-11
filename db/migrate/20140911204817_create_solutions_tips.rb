class CreateSolutionsTips < ActiveRecord::Migration
  def change
    create_table :solutions_tips do |t|
      t.integer "solution_id", null: false
      t.integer "tip_id",      null: false
    end
  end
end
