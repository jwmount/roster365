class CreateSolutionsTips < ActiveRecord::Migration
  def change
    create_table :solutions_tips, :id => false do |t|
      t.integer :solution_id
      t.integer :tip_id
    end
  end
end
