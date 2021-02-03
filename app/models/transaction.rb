# frozen_string_literal: true

class Transaction < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :contact, optional: true

  # Constants
  TRANSACTION_TYPES = %w[credit debit].freeze
  # If page info is not given, first page of max 30 records is returned
  DEFAULT_PAGE_SIZE = 30
  DEFAULT_PAGE = 1

  # Validations
  # Good to have validations at both DB and app level
  validates_presence_of :amount, :transaction_type
  # Transaction amount should be non-negative
  validates :amount, numericality: { greater_than: 0 }
  # Transaction type can be either 'credit' or 'debit'
  validates :transaction_type,
            inclusion: { in: TRANSACTION_TYPES,
                         message: '%<value>s is not a valid transaction type' }
  # Transaction may or may not belong to a Contact. In case they do, they
  # belong to an existing contact
  validate :valid_contact_id

  # Enums
  enum transaction_type: TRANSACTION_TYPES

  class << self
    include QueryBuilder

    # NOTE: The query irrespective of opts will always use either of the 2
    # indices
    # @param opts [Hash] Contains querying/filtering options
    # Example - { page: 3, per_page: 10,
    #             contact_id: 2, transaction_type: 'debit', uid: 2 }
    def query(opts)
      # The order is important
      records = filter_by_user_id(opts[:uid])
      records = filter_by_transaction_type(records, opts[:transaction_type])
      records = filter_by_contact_id(records, opts[:contact_id])
      records = order_by_created_at(records)
      filter_page_wise_records(records, opts[:page], opts[:per_page])
    end
  end

  # Custom validations

  def valid_contact_id
    valid_contact_ids = Contact.ids << nil
    return unless valid_contact_ids.exclude?(contact_id)

    message = "#{contact_id} is not a valid contact id. Try not giving it"
    errors.add(:contact_id, message)
    false
  end
end
