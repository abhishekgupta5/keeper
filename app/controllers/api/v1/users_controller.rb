# frozen_string_literal: true

# User controller
class Api::V1::UsersController < ApplicationController
  include Response
  # POST /users
  def create
    json_response(User.create, status: :ok)
  end
end
