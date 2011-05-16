class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :referer
      t.string :ip
      t.integer :created_by
      t.timestamp :created_at
    end
  end

  def self.down
    drop_table :events
  end
end
