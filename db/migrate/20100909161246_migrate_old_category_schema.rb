class MigrateOldCategorySchema < ActiveRecord::Migration
  def self.up
    Photo.find(:all, :select => 'DISTINCT category AS foo').map{|s| s.foo}.each do |cat|
      Category.create :name => cat
    end
    Photo.all.each do |photo|
      cat = Category.find_by_name photo.category
      photo.category_id = cat.id
      photo.save!
    end
  end

  def self.down
    raise 'Cannot undo!'
  end
end
