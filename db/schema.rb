# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_31_224919) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "name, COALESCE(phone_number, '-1'::character varying)", name: "uniq_index_on_contacts", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.float "amount", null: false
    t.integer "transaction_type", null: false, comment: "Enum - debit, credit"
    t.bigint "contact_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "user_id, transaction_type, COALESCE(contact_id, ('-1'::integer)::bigint), amount", name: "uniq_index_on_transactions", unique: true
    t.index "user_id, transaction_type, COALESCE(contact_id, ('-1'::integer)::bigint), created_at DESC", name: "index_on_user_id_other_fields_and_created_at_desc"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
