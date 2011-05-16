class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :status, :default => 'active'
      t.string :name
      t.string :email
      t.string :purpose
      t.string :description, :limit => 40000
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
