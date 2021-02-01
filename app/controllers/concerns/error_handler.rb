# frozen_string_literal: true

# Helper module for ErrorHandling in controller response
module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    rescue_from Errors::InvalidTransactionType, with: :handle_record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActiveRecord::RecordNotUnique, with: :handle_duplicate_record
    rescue_from Errors::InvalidUidError, with: :handle_invalid_uid
    rescue_from ArgumentError, with: :handle_argument_error
  end

  def handle_record_not_found(error)
    json_response({ message: error.message }, status: :not_found)
  end

  def handle_record_invalid(error)
    json_response({ message: error.message }, status: :unprocessable_entity)
  end

  def handle_invalid_uid(error)
    json_response({ message: error.message }, status: :unauthorized)
  end

  def handle_argument_error(error)
    json_response({ message: error.message }, status: :bad_request)
  end

  # TODO: Throws correct but non-user friendly error. Fix it
  def handle_duplicate_record(error)
    json_response({ message: error.message }, status: :forbidden)
  end
end
