create_table "payment_interactions", force: :cascade do |t|
  t.integer  "user_id",         limit: 4
  t.string   "transaction_status", limit: 255
  t.string   "transaction_amount", limit: 255
  t.text     "request_params",     limit: 65535
  t.text     "response_params",    limit: 65535
  t.datetime "created_at"
  t.datetime "updated_at"
end