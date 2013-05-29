class RenameQuoteContactId < ActiveRecord::Migration
  def change
    rename_column :quotes, :contact_id, :rep_id
  end

end
