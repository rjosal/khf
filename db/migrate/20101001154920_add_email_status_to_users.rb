class AddEmailStatusToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_status, :string, :default => 'good'
  end

  def self.down
    remove_column :users, :email_status
  end
end
