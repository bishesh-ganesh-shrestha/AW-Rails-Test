class ApplicationController < ActionController::API
  before_action :underscore_params

  private

  # converts incoming camelCase params to snake_case
  def underscore_params
    params.deep_transform_keys! { |key| key.to_s.underscore }
  end

  # authenticate every protected request
  def authenticate_request!
    token = extract_token

    if token.nil?
      render json: { error: "Missing token" }, status: :unauthorized
      return
    end

    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id])

    unless @current_user
      render json: { error: "User not found" }, status: :unauthorized
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :unauthorized
  end

  def extract_token
    auth_header = request.headers["Authorization"]
    auth_header&.split(" ")&.last
  end
end
