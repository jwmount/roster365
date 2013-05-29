class AddLoadTipInvPayClientToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :pay_load_client, :decimal
    add_column :solutions, :invoice_load_client, :decimal
    add_column :solutions, :pay_tip_client, :decimal
    add_column :solutions, :invoice_tip_client, :decimal
  end
end
