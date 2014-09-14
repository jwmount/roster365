class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :user_id
      t.text :title
      t.integer :count

      t.timestamps
    end
  end
end
