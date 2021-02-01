# frozen_string_literal: true

module RequestSpecHelper
  # Parse JSON response to ruby hash
  def parsed_response
    JSON.parse(response.body)
  end

  def fill_data(user, contact)
    20.times do |count|
      type = count.even? ? 'credit' : 'debit'
      contact.transactions.create(user_id: user.id, transaction_type: type,
                                  amount: 100 * count, created_at: Time.zone.now - count.days)
    end
  end
end
