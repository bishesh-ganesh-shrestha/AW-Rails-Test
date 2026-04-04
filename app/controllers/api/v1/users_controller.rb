# Handles user registration
class Api::V1::UsersController < ApplicationController
  # POST /api/v1/users/signup
  # Registers a new user
  #
  # @return [JSON] created user with token or error
  def signup
    user = User.new(user_params)

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: UserSerializer.new(user, params: { token: token }).serializable_hash,
             status: :created
    else
      head :unprocessable_entity
    end
  end

  private

  # Permitted user parameters
  #
  # @return [ActionController::Parameters]
  def user_params
    params.permit(:first_name, :last_name, :email, :password, :country)
  end
end
