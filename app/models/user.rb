# frozen_string_literal: true

class User < ApplicationRecord
  # Associations
  has_many :transactions
end
