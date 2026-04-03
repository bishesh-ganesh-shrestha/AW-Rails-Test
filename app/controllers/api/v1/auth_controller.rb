class Api::V1::AuthController < ApplicationController
  def signin
    user = User.find_by(email: auth_params[:email])

    if user&.authenticate(auth_params[:password])
      token = JsonWebToken.encode(user_id: user.id)

      render json: {
        data: {
          id: user.id,
          type: "users",
          attributes: {
            token: token,
            email: user.email,
            name: "#{user.full_name}",
            country: user.country,
            createdAt: user.created_at,
            updatedAt: user.updated_at
          }
        }
      }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
