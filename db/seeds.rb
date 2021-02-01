# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create

10.times do |count|
  contact = Contact.create(name: "Starship#{count}",
                           phone_number: "1234567#{count}")
  20.times do |count|
    type = count % 2 == 0 ? 'credit' : 'debit'
    contact.transactions.create(user_id: user.id, transaction_type: type,
                                amount: 100 * count, created_at: Time.zone.now - count.days)
  end
end
10.times do |count|
  type = count % 3 == 0 ? 'credit' : 'debit'
  Transaction.create(user_id: user.id, transaction_type: type,
                              amount: 200 * count, created_at: Time.zone.now - count.days)
end

