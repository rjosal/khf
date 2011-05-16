class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :status, :default => 'active'
      t.integer :headline_id
      t.string :comment

      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
