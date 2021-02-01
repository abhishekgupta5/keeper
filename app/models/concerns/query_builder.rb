# frozen_string_literal: true

# Used to build the transaction query allowing several filters
module QueryBuilder
  include Errors
  # @param user_id [Integer] User id
  # @return [Transaction::ActiveRecord_Relation]
  def filter_by_user_id(user_id)
    Transaction.where(user_id: user_id)
  end

  # @param records [Transaction::ActiveRecord_Relation]
  # @return [Transaction::ActiveRecord_Relation]
  def order_by_created_at(records)
    records.order(created_at: :desc)
  end

  # Warning: We are using will_paginate gem which uses simple limit/offset
  # based pagination. While this works for normal ranges, it should be noted
  # that if page number (offset) is too large, this will be inefficient
  # because Postgres actually scans the table to shift the offset.
  # Better methods exist to attain this.
  # @param records [Transaction::ActiveRecord_Relation]
  # @param page [Integer] Page number
  # @param per_page [Integer] Number of transactions per page
  # @return [Transaction::ActiveRecord_Relation]
  def filter_page_wise_records(records, page, per_page)
    records.paginate(page: page || DEFAULT_PAGE,
                     per_page: per_page || DEFAULT_PAGE_SIZE)
  end

  # @param records [Transaction::ActiveRecord_Relation]
  # @param contact_id [Integer] contact id
  # @return [Transaction::ActiveRecord_Relation]
  def filter_by_contact_id(records, contact_id)
    coalesce_value = contact_id.blank? ? -1 : contact_id
    coalesce_clause = "COALESCE(contact_id, -1) = #{coalesce_value}"
    records.where(coalesce_clause)
  end

  # @param records [[Transaction::ActiveRecord_Relation]]
  # @param transaction_type [String] 'debit' or 'credit'
  # @return [Transaction::ActiveRecord_Relation]
  # If transaction type is not given, all is default.
  # For incorrect value, error is raised
  def filter_by_transaction_type(records, transaction_type)
    if transaction_type.present? &&
       Transaction::TRANSACTION_TYPES.exclude?(transaction_type)
      raise InvalidTransactionType
    end

    transaction_type = Transaction::TRANSACTION_TYPES if transaction_type.blank?

    records.where(transaction_type: transaction_type)
  end
end
