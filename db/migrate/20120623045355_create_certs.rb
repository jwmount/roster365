class CreateCerts < ActiveRecord::Migration
  def change
    create_table :certs do |t|
      t.integer     :certifiable_id
      t.string      :certifiable_type
      t.integer     :certificate_id
      t.datetime    :expires_on
      t.string      :serial_number
      t.boolean     :permanent
      t.boolean     :active
    end
  end
  
  def self.down
    drop_table :certs
  end
  
end
