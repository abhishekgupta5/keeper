# frozen_string_literal: true

# Helper methods for controller responses
module Response
  def json_response(object, status: :ok)
    render json: object, status: status
  end
end
