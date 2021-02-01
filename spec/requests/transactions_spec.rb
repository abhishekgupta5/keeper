# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transaction API', type: :request do
  # Tests for POST /transactions
  describe 'POST api/v1/transactions' do
    before(:all) do
      @user = create(:user)
      @headers = { 'uid' => @user.id }
      @contact = create(:contact)
      @valid_params = { amount: 24.5,
                        transaction_type: 'credit',
                        contact_id: @contact.id }
      post '/api/v1/transactions', params: @valid_params, headers: @headers
    end

    context 'when the params are valid' do
      it 'creates a transaction successfully' do
        expect(parsed_response['amount']).to eq(24.5)
        expect(parsed_response['contact_id']).to eq(@contact.id)
        expect(parsed_response['transaction_type']).to eq('credit')
        expect(parsed_response['user_id']).to eq(@user.id)
        expect(response).to have_http_status(201)
      end

      it 'idempotence check - duplicate transactions should throw error' do
        expect do
          post '/api/v1/transactions', params: @valid_params, headers: @headers
        end.to change(Transaction, :count).by(0)
        expect(response).to have_http_status(403)
        expect(parsed_response['message']).to match(/PG::UniqueViolation/)
      end
    end

    context 'when the params are invalid' do
      it 'when amount is not-positive' do
        invalid_params = { amount: 0,
                           transaction_type: 'credit',
                           contact_id: @contact.id }
        expect do
          post '/api/v1/transactions', params: invalid_params, headers: @headers
        end.to change(Transaction, :count).by(0)
        expect(parsed_response['message'])
          .to match(/Validation failed: Amount must be greater than 0/)
        expect(response).to have_http_status(422)
      end

      it 'when transaction_type is other than credit or debit' do
        invalid_params = { amount: 10,
                           transaction_type: 'something',
                           contact_id: @contact.id }
        expect do
          post '/api/v1/transactions', params: invalid_params, headers: @headers
        end.to change(Transaction, :count).by(0)
        expect(parsed_response['message'])
          .to match(/something' is not a valid transaction_type/)
        expect(response).to have_http_status(400)
      end

      it "when contact doesn't exist in db" do
        invalid_params = { amount: 14,
                           transaction_type: 'debit',
                           contact_id: @contact.id + 1 }
        expect do
          post '/api/v1/transactions', params: invalid_params, headers: @headers
        end.to change(Transaction, :count).by(0)
        expect(parsed_response['message'])
          .to match(/Validation failed: Contact #{@contact.id + 1} is not a valid contact id/)
        expect(response).to have_http_status(422)
      end
    end
  end

  # Tests for GET /transactions
  describe 'GET api/v1/transactions' do
    context 'Successful working of the API' do
      before(:each) do
        @user = create(:user)
        @headers = { 'uid' => @user.id }
        @contact = create(:contact)
        @valid_params = { page: 1,
                          per_page: 5,
                          contact_id: @contact.id,
                          transaction_type: 'credit' }
        fill_data(@user, @contact)
      end

      it 'API working - paginated response sorted by created_at DESC' do
        get '/api/v1/transactions', params: @valid_params, headers: @headers
        contact_id_clause = "COALESCE(contact_id, -1) = #{@contact.id}"
        expected_ids =
          Transaction.where(user_id: @user.id).credit.where(contact_id_clause)
                     .order(created_at: :desc)
                     .paginate(page: @valid_params[:page], per_page: @valid_params[:per_page]).ids
        # It's sufficient to check only the order and count of ids that we get
        expect(parsed_response.pluck('id')).to eq(expected_ids)
        expect(response).to have_http_status(200)
      end

      it 'API working - when contact id not provided' do
        expect(Transaction.where(contact_id: nil)).to be_empty
        new_record = create(:transaction, user_id: @user.id)
        new_params = { page: 1,
                       per_page: 50,
                       transaction_type: 'credit' }
        get '/api/v1/transactions', params: new_params, headers: @headers
        contact_id_clause = 'COALESCE(contact_id, -1) = -1'
        expected_ids =
          Transaction.where(user_id: @user.id).credit.where(contact_id_clause)
                     .order(created_at: :desc)
                     .paginate(page: @valid_params[:page], per_page: @valid_params[:per_page]).ids
        expect(parsed_response.pluck('id')).to eq(expected_ids)
        # Only the new record if should be shown
        expect(parsed_response.pluck('id')).to eq([new_record.id])
        expect(response).to have_http_status(200)
      end

      it 'API working - when transaction_type not provided, both fetched' do
        new_params = { page: 1,
                       per_page: 50,
                       contact_id: @contact.id }
        get '/api/v1/transactions', params: new_params, headers: @headers
        contact_id_clause = "COALESCE(contact_id, -1) = #{@contact.id}"
        expected_ids =
          Transaction.where(user_id: @user.id)
                     .where(transaction_type: Transaction::TRANSACTION_TYPES)
                     .where(contact_id_clause).order(created_at: :desc)
                     .paginate(page: new_params[:page], per_page: new_params[:per_page]).ids
        expect(parsed_response.pluck('id')).to eq(expected_ids)
        expect(response).to have_http_status(200)
      end
    end
  end
end
