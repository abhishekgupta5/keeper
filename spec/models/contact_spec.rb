# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  # Association test
  it { should have_many(:transactions) }
  # Validation tests
  it { should validate_presence_of(:name) }
end
