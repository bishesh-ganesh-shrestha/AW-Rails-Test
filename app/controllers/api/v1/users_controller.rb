class Api::V1::UsersController < ApplicationController
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

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :country)
  end
end
