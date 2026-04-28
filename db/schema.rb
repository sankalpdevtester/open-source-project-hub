# This is a Rails database schema file, which defines the structure of the database.

ActiveRecord::Schema.define(version: 2024_09_16_000001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discussions", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.references "project", null: false, foreign_key: true
    t.references "user", null: false, foreign_key: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "repository_url"
    t.references "user", null: false, foreign_key: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", id: :serial, force: :cascade do |t|
    t.text "content"
    t.references "project", null: false, foreign_key: true
    t.references "user", null: false, foreign_key: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "discussions", ["project_id"], name: "index_discussions_on_project_id"
  add_index "discussions", ["user_id"], name: "index_discussions_on_user_id"
  add_index "projects", ["user_id"], name: "index_projects_on_user_id"
  add_index "reviews", ["project_id"], name: "index_reviews_on_project_id"
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"

end