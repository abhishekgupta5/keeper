# frozen_string_literal: true

class Contact < ApplicationRecord
  # Associations
  has_many :transactions

  # Validations
  # Good to have validations at both DB and app level
  # Assuming that name is must and phone number can be empty
  validates_presence_of :name
end
