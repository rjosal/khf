class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :status, :default => 'active'
      t.string :category
      t.string :filename
      t.string :caption
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
