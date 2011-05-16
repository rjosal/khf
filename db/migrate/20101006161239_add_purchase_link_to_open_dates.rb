class AddPurchaseLinkToOpenDates < ActiveRecord::Migration
  def self.up
    add_column :open_dates, :purchase_link, :string
  end

  def self.down
    remove_column :open_dates, :purchase_link
  end
end
