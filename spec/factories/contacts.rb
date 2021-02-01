# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
