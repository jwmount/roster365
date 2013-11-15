class CreateDispatches < ActiveRecord::Migration
  def change
    create_table :dispatches do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
