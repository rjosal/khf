class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :status, :default => 'active'
      t.string :name
      t.string :email
      t.string :role
      t.string :hashed_password
      t.string :salt
      t.timestamp :last_login

      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
