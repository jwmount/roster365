class RemoveLoadTipInvPayClientToSolution < ActiveRecord::Migration
  def up
    remove_column :solutions, :inv_client_1
    remove_column :solutions, :inv_client_2
  end

  def down
    add_column :solutions, :inv_client_2, :string
    add_column :solutions, :inv_client_1, :string
  end
end
