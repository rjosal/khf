class AddPurchaseLinkToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :purchase_link, :string
  end

  def self.down
    remove_column :tickets, :purchase_link
  end
end
