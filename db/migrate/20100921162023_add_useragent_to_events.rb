class AddUseragentToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :useragent, :string
  end

  def self.down
    remove_column :events, :useragent
  end
end
