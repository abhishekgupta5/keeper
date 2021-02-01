# frozen_string_literal: true

# TransactionControllerHelper
module TransactionsControllerHelper
  private
  def set_user
    user_id = request.headers['uid']
    @user = User.find_by(id: user_id)
    raise Errors::InvalidUidError if @user.nil?
  end

  def create_transaction_params
    params.permit(:amount, :transaction_type, :contact_id)
  end

  def query_transaction_params
    params.permit(:page, :per_page, :contact_id, :transaction_type)
  end
end
