class MigratePhotoCategoryDirectoriesOnDisk < ActiveRecord::Migration
  def self.up
    Category.all.each do |cat|
      dir = Rails.root.join('public', 'images', 'photos', cat.name)
      new_dir = Rails.root.join('public', 'images', 'photos', "category_#{cat.id}")
      File.rename(dir, new_dir) if File.directory?(dir)
    end
  end

  def self.down
    Category.all.each do |cat|
      dir = Rails.root.join('public', 'images', 'photos', "category_#{cat.id}")
      new_dir = Rails.root.join('public', 'images', 'photos', cat.name)
      File.rename(dir, new_dir) if File.directory?(dir)
    end
  end
end
