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

ActiveRecord::Schema.define(version: 20170922193301) do

  create_table "bookings", force: :cascade do |t|
    t.string "seatno"
    t.date "bookingdate"
    t.string "status"
    t.date "doj"
    t.integer "user_id"
    t.integer "passenger_id"
    t.integer "flight_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bookingno"
    t.string "classname"
    t.index ["flight_id"], name: "index_bookings_on_flight_id"
    t.index ["passenger_id"], name: "index_bookings_on_passenger_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "flights", force: :cascade do |t|
    t.time "arrival_time"
    t.time "departure_time"
    t.string "source"
    t.string "destination"
    t.string "airlines"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flighttypes", force: :cascade do |t|
    t.string "classname"
    t.integer "noofseats"
    t.integer "price"
    t.integer "flight_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_id"], name: "index_flighttypes_on_flight_id"
  end

  create_table "passengers", force: :cascade do |t|
    t.string "name"
    t.string "aadharno"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.boolean "sunday"
    t.integer "flight_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_id"], name: "index_schedules_on_flight_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "emailid"
    t.string "contactno"
    t.string "credate"
    t.string "password"
    t.boolean "verified"
    t.boolean "isadmin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
