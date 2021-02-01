class AddIndexOnTransactions < ActiveRecord::Migration[6.0]

  INDEX_TYPE_NAME_MAP = { unique: "uniq_index_on_transactions",
                          created_at: "index_on_user_id_other_fields_and_created_at_desc" }

  # Note: Having these 2 indexes seem redundant but since amount is part of the
  # idempotence check and queries are ordered by created_at, it'll ensure index
  # scans in the cases. If amount wouldn't be part of the idempotence check,
  # then a single index would have sufficed our usecase.
  def up
    unique_index_sql = <<~SQL
      CREATE UNIQUE INDEX IF NOT EXISTS #{INDEX_TYPE_NAME_MAP[:unique]}
      ON transactions
      (user_id, transaction_type, COALESCE(contact_id, -1), amount)
    SQL

    created_at_index_sql = <<~SQL
    CREATE INDEX IF NOT EXISTS #{INDEX_TYPE_NAME_MAP[:created_at]}
      ON transactions
      (user_id, transaction_type, COALESCE(contact_id, -1), created_at DESC)
    SQL

    execute(unique_index_sql)
    execute(created_at_index_sql)
  end

  def down
    INDEX_TYPE_NAME_MAP.values.each do |index_name|
      sql = <<~SQL
        DROP INDEX IF EXISTS #{index_name}
      SQL
      execute(sql)
    end
  end
end
