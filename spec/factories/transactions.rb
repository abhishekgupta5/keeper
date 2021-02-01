# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    amount { Faker::Number.decimal(l_digits: 3, r_digits: 3) }
    transaction_type { 'credit' }
    contact { nil }
    user { User.create! }
  end
end
