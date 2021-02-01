# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contacts API', type: :request do
  # Tests for POST /contacts
  describe 'POST api/v1/contacts' do
    let(:valid_params) { { name: 'Hello World', phone_number: '1234567890' } }

    context 'when the params are valid' do
      before { post '/api/v1/contacts', params: valid_params }

      it 'creates a contact successfully' do
        expect(parsed_response['name']).to eq('Hello World')
        expect(parsed_response['phone_number']).to eq('1234567890')
        expect(response).to have_http_status(201)
      end

      it 'idempotence check - duplicate contacts should throw error' do
        new_params = { name: 'Hello World', phone_number: '1234567890' }
        expect do
          post '/api/v1/contacts', params: new_params
        end.to change(Contact, :count).by(0)
        expect(response).to have_http_status(403)
        expect(parsed_response['message']).to match(/PG::UniqueViolation/)
      end
    end

    context 'when the params are invalid' do
      before { post '/api/v1/contacts', params: { phone_number: '123456789' } }

      it 'returns proper error message' do
        expect(parsed_response['message'])
          .to match(/Validation failed: Name can't be blank/)
        expect(response).to have_http_status(422)
      end
    end
  end
end
