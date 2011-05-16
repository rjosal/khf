class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :status, :default => 'active'
      t.string :name
      t.string :href
      t.integer :position
      t.string :filename
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
