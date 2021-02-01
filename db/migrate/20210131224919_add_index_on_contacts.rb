class AddIndexOnContacts < ActiveRecord::Migration[6.0]
  def up
    sql = <<~SQL
      CREATE UNIQUE INDEX IF NOT EXISTS uniq_index_on_contacts
      ON contacts (name, COALESCE(phone_number, '-1'))
    SQL
    execute(sql)
  end

  def down
    sql = <<~SQL
      DROP INDEX IF EXISTS uniq_index_on_contacts
    SQL
    execute(sql)
  end
end
