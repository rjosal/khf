# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110806215619) do

  create_table "abouts", :force => true do |t|
    t.string   "status",                       :default => "active"
    t.string   "title"
    t.string   "description", :limit => 40000
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "status",     :default => "active"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "status"
    t.integer  "headline_id", :null => false
    t.string   "comment"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "status",      :default => "active"
    t.string   "name"
    t.string   "email"
    t.string   "purpose"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "referer"
    t.string   "ip"
    t.integer  "created_by"
    t.datetime "created_at"
    t.string   "useragent"
  end

  create_table "headlines", :force => true do |t|
    t.string   "status"
    t.string   "title"
    t.string   "post",       :limit => 40000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  create_table "links", :force => true do |t|
    t.string   "status",     :default => "active"
    t.string   "name"
    t.string   "href"
    t.integer  "position"
    t.string   "filename"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_dates", :force => true do |t|
    t.string   "status"
    t.date     "date_open"
    t.time     "start_time"
    t.time     "lights_on_end_time"
    t.time     "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "purchase_link"
  end

  create_table "photos", :force => true do |t|
    t.string   "status",      :default => "active"
    t.string   "filename"
    t.string   "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "category_id"
  end

# Could not dump table "themes" because of following StandardError
#   Unknown type 'year(4)' for column 'year_active'

  create_table "tickets", :force => true do |t|
    t.string   "status"
    t.string   "name"
    t.decimal  "price",         :precision => 4, :scale => 2
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "purchase_link"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                               :null => false
    t.string   "role",                                :null => false
    t.string   "status",                              :null => false
    t.string   "hashed_password",                     :null => false
    t.string   "salt"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_status",    :default => "good"
  end

end
