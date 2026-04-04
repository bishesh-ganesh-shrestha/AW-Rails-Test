# Handles user authentication (sign in)
class Api::V1::AuthController < ApplicationController
  # POST /api/v1/auth/signin
  # Authenticates user and returns JWT token
  #
  # @return [JSON] user data with token or error message
  def signin
    user = User.find_by(email: auth_params[:email])

    if user&.authenticate(auth_params[:password])
      token = JsonWebToken.encode(user_id: user.id)

      render json: UserSerializer.new(user, params: { token: token }).serializable_hash,
             status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  # Permitted authentication params
  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
