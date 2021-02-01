class AddConstraintsOnTransactions < ActiveRecord::Migration[6.0]
  def up
    sql = <<~SQL
      ALTER TABLE transactions ADD CONSTRAINT
        check_amount_non_negative_and_valid_transaction_type
      CHECK (amount > 0 AND transaction_type IN (0, 1))
    SQL
    execute(sql)
  end

  def down
    sql = <<~SQL
      ALTER TABLE transactions DROP CONSTRAINT
        check_amount_non_negative_and_valid_transaction_type
    SQL
    execute(sql)
  end
end
