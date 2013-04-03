# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130402063122) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.string   "token_secret"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "boxes", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "photo_id"
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "img_sizes", :force => true do |t|
    t.integer  "photo_id"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "photo_id"
    t.integer  "quantity",   :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "source_id"
    t.integer  "target_id"
    t.string   "relation_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "notifications", ["source_id", "target_id", "relation_type"], :name => "index_notifications_on_source_id_and_target_id_and_relation_type"

  create_table "photos", :force => true do |t|
    t.string   "description"
    t.string   "name"
    t.integer  "box_id"
    t.integer  "origin_owner_id"
    t.string   "image"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "source_id"
    t.integer  "target_id"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "reports", ["source_id", "target_id", "title"], :name => "index_reports_on_source_id_and_target_id_and_title"

  create_table "user_box_follows", :force => true do |t|
    t.integer  "user_id"
    t.integer  "box_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_follow_relationships", :force => true do |t|
    t.integer  "following_id"
    t.integer  "follower_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "user_follow_relationships", ["follower_id", "following_id"], :name => "index_user_follow_relationships_on_follower_id_and_following_id", :unique => true
  add_index "user_follow_relationships", ["follower_id"], :name => "index_user_follow_relationships_on_follower_id"
  add_index "user_follow_relationships", ["following_id"], :name => "index_user_follow_relationships_on_following_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "gender"
    t.string   "avatar"
    t.boolean  "active"
    t.boolean  "admin"
    t.boolean  "banned"
    t.boolean  "verified"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token",    :default => "", :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["single_access_token"], :name => "index_users_on_single_access_token"

end
