# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110326002447) do

  create_table "content_modules", :force => true do |t|
    t.string   "key"
    t.string   "description"
    t.boolean  "has_title"
    t.string   "title"
    t.boolean  "has_content"
    t.text     "content"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.boolean  "has_image"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.boolean  "has_attachment"
    t.text     "meta_description"
    t.boolean  "has_meta_description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title"
    t.boolean  "has_meta_title"
  end

  create_table "mt_pdf_surveys", :force => true do |t|
    t.string   "title"
    t.text     "material"
    t.text     "finish"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_items", :force => true do |t|
    t.integer  "status_id",                               :default => 1
    t.integer  "news_type_id",                            :default => 1
    t.integer  "position"
    t.boolean  "home_page",                               :default => true
    t.string   "title"
    t.text     "summary"
    t.text     "body"
    t.string   "location"
    t.datetime "publish_date"
    t.string   "image_caption"
    t.string   "image_url",               :limit => 1024
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "show_image_mode_id",                      :default => 2
    t.string   "attachment_title"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quote_requests", :force => true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "phone"
    t.string   "email"
    t.string   "address1"
    t.string   "address2"
    t.string   "state"
    t.string   "city"
    t.string   "zip"
    t.string   "country"
    t.string   "fax"
    t.string   "services"
    t.string   "lead_time"
    t.string   "annual_use"
    t.string   "release_value"
    t.integer  "order_frequency_id"
    t.text     "note"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quote_status_id",    :default => 1
    t.string   "other_service"
  end

  create_table "turkee_imported_assignments", :force => true do |t|
    t.string   "assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "turkee_imported_assignments", ["assignment_id"], :name => "index_turkee_imported_assignments_on_assignment_id", :unique => true

  create_table "turkee_tasks", :force => true do |t|
    t.string   "hit_url"
    t.boolean  "sandbox"
    t.string   "task_type"
    t.text     "hit_title"
    t.text     "hit_description"
    t.string   "hit_id"
    t.decimal  "hit_reward",          :precision => 10, :scale => 2
    t.integer  "hit_num_assignments"
    t.integer  "hit_lifetime"
    t.string   "form_url"
    t.boolean  "complete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "notification_preference"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.integer  "user_status_id"
    t.integer  "user_role_id"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",             :default => 0
    t.integer  "failed_login_count",      :default => 0
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
