# frozen_string_literal: true

# Custom Errors
module Errors
  # Raised when user with uid not in DB
  class InvalidUidError < StandardError
    def message
      "Invalid 'uid' in headers"
    end
  end

  # Raised when transaction type is not supported
  class InvalidTransactionType < StandardError
    def message
      "Transaction type can either be 'debit' or 'credit'"
    end
  end
end
