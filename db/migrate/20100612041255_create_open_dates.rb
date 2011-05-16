class CreateOpenDates < ActiveRecord::Migration
  def self.up
    create_table :open_dates do |t|
      t.string :status, :default => 'active'
      t.date :date_open
      t.time :start_time
      t.time :lights_on_end_time
      t.time :end_time

      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end

  def self.down
    drop_table :open_dates
  end
end
