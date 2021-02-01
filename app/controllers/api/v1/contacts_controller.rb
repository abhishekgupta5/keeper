# frozen_string_literal: true

# Contacts controller
class Api::V1::ContactsController < ApplicationController
  include Response
  include ErrorHandler
  # POST /contacts
  def create
    contact = Contact.create!(contact_params)
    json_response(contact, status: :created)
  end

  private

  def contact_params
    params.permit(:name, :phone_number)
  end
end
