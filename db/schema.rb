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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140618185339) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_profiles", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_profiles", ["user_id"], name: "index_admin_profiles_on_user_id", using: :btree

  create_table "authentications", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "body"
    t.string   "status",                default: "Published"
    t.integer  "discussion_id"
    t.integer  "comment_id"
    t.integer  "student_profile_id"
    t.integer  "instructor_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_profile_id"
  end

  add_index "comments", ["admin_profile_id"], name: "index_comments_on_admin_profile_id", using: :btree
  add_index "comments", ["comment_id"], name: "index_comments_on_comment_id", using: :btree
  add_index "comments", ["discussion_id"], name: "index_comments_on_discussion_id", using: :btree
  add_index "comments", ["instructor_profile_id"], name: "index_comments_on_instructor_profile_id", using: :btree
  add_index "comments", ["student_profile_id"], name: "index_comments_on_student_profile_id", using: :btree

  create_table "discussions", force: true do |t|
    t.string   "name"
    t.string   "status",                default: "Active"
    t.integer  "comments_count",        default: 0,        null: false
    t.integer  "workshop_id"
    t.integer  "student_profile_id"
    t.integer  "instructor_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body",                  default: ""
    t.integer  "admin_profile_id"
  end

  add_index "discussions", ["admin_profile_id"], name: "index_discussions_on_admin_profile_id", using: :btree
  add_index "discussions", ["instructor_profile_id"], name: "index_discussions_on_instructor_profile_id", using: :btree
  add_index "discussions", ["student_profile_id"], name: "index_discussions_on_student_profile_id", using: :btree
  add_index "discussions", ["workshop_id"], name: "index_discussions_on_workshop_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "status",               default: "Active"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "workshop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cost_in_cents",        default: 0
    t.integer  "registrations_count",  default: 0
    t.integer  "registrations_max",    default: 0
    t.datetime "registration_ends_at"
  end

  add_index "events", ["workshop_id"], name: "index_events_on_workshop_id", using: :btree

  create_table "instructor_profiles", force: true do |t|
    t.string   "name"
    t.text     "bio"
    t.string   "avatar"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instructor_profiles", ["user_id"], name: "index_instructor_profiles_on_user_id", using: :btree

  create_table "instructor_profiles_events", force: true do |t|
    t.integer  "instructor_profile_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instructor_profiles_events", ["instructor_profile_id", "event_id"], name: "rel_instructor_profiles_events", unique: true, using: :btree

  create_table "registrations", force: true do |t|
    t.integer  "event_id"
    t.integer  "student_profile_id"
    t.string   "status",               default: "Pending"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount_paid_in_cents", default: 0
    t.string   "stripe_token"
  end

  add_index "registrations", ["event_id", "student_profile_id"], name: "index_registrations_on_event_id_and_student_profile_id", unique: true, using: :btree

  create_table "student_profiles", force: true do |t|
    t.string   "name"
    t.text     "bio"
    t.string   "avatar"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_profiles", ["user_id"], name: "index_student_profiles_on_user_id", using: :btree

  create_table "tracks", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "status",      default: "Active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort",        default: 0
  end

  create_table "users", force: true do |t|
    t.string   "email",                                       null: false
    t.string   "crypted_password",                            null: false
    t.string   "salt",                                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer  "failed_logins_count",             default: 0
    t.datetime "lock_expires_at"
    t.string   "unlock_token"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "workshop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["user_id", "workshop_id"], name: "index_votes_on_user_id_and_workshop_id", unique: true, using: :btree

  create_table "workshops", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "status",            default: "Active"
    t.string   "banner"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes_count",       default: 0
    t.integer  "votes_goal",        default: 0
    t.integer  "track_id"
    t.integer  "discussions_count", default: 0,        null: false
    t.integer  "sort",              default: 0
  end

  add_index "workshops", ["track_id"], name: "index_workshops_on_track_id", using: :btree

end
