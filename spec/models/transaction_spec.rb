# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  # Association test
  it { should belong_to(:user) }
  # Validation tests
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:transaction_type) }
  it 'amount greater than 0' do
    expected_error_message = 'Validation failed: Amount must be greater than 0'
    expect do
      create(:transaction, amount: -10)
    end.to raise_error(ActiveRecord::RecordInvalid, expected_error_message)
  end

  it 'invalid transaction type' do
    expect do
      create(:transaction, transaction_type: 'random')
    end.to raise_error(ArgumentError,
                       "'random' is not a valid transaction_type")
  end

  it 'invalid contact reference' do
    expect(Contact.count).to be_zero
    expected_error_message = 'Validation failed: Contact 10 is not a valid '\
                             'contact id. Try not giving it'
    expect do
      create(:transaction, contact_id: 10)
    end.to raise_error(ActiveRecord::RecordInvalid, expected_error_message)
  end

  it 'can exist without a contact' do
    expect(create(:transaction).contact_id).to be_nil
  end
end
