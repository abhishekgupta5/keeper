# frozen_string_literal: true

# Transaction controller
class Api::V1::TransactionsController < ApplicationController
  include Response
  include ErrorHandler
  include TransactionsControllerHelper

  before_action :set_user, only: %i[show create]

  # GET /transactions
  def show
    opts = query_transaction_params.merge!({ uid: @user.id })
    json_response(Transaction.query(opts), status: :ok)
  end

  # POST /transactions
  def create
    attributes = create_transaction_params.merge!({ user_id: @user.id })
    transaction = Transaction.create!(attributes)
    json_response(transaction, status: :created)
  end
end
