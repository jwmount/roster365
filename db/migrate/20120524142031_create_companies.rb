class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :credit_terms
      t.boolean :PO_required
      t.boolean :active
      t.string :MYOB_number

      t.timestamps
    end
  end
  
  def self.down
    drop_table :companies
  end
  
end
