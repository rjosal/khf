class PhotosRemoveCategory < ActiveRecord::Migration
  def self.up
    remove_column :photos, :category
  end

  def self.down
    add_column :photos, :category, :string
  end
end
