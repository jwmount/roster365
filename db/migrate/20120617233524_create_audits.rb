class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.integer    :auditable_id
      t.string     :auditable_type
      t.integer    :association_id
      t.string     :association_type
      t.integer    :user_id
      t.string     :username
      t.string     :action
      t.text       :audited_changes
      t.integer    :version
      t.string     :comment
      t.string     :remote_address
      t.datetime   :created_at
    end
  end
  def self.down
    drop_table :audits
  end

end
