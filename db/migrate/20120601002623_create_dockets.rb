class CreateDockets < ActiveRecord::Migration
  def change
    create_table :dockets do |t|
      t.integer    :engagement_id
      t.integer    :contact_id
      t.string     :booking_no
      t.datetime   :date_worked
      t.datetime   :dated
      t.datetime   :received_on
      t.boolean    :operator_signed
      t.boolean    :client_signed
      t.boolean    :T360_approved
      t.integer    :T360_approved_by
      t.datetime   :T360_approved_on
      t.boolean    :T360_2nd_approval
      t.integer    :T360_2nd_approval_by
      t.datetime   :T360_2nd_approval_on
      t.decimal    :a_inv_pay,              :precision => 7,  :scale => 2
      t.decimal    :b_inv_pay,              :precision => 7,  :scale => 2
      t.decimal    :supplier_inv_pay,       :precision => 7,  :scale => 2
      t.timestamps
    end
  end
  def self.down
    drop_table :dockets
  end

end
