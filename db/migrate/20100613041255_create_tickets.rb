class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :status, :default => 'active'
      t.string :name
      t.decimal :price
      t.string :description

      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
