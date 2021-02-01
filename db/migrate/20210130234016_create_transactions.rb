class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.float :amount, null: false
      t.integer :transaction_type, null: false, comment: 'Enum - debit, credit'
      t.references :contact, foreign_key: false, index: false
      t.references :user, foreign_key: false, index: false, null: false

      t.timestamps
    end
  end
end
