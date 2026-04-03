class Api::V1::UsersController < ApplicationController
  def signup
    user = User.new(user_params)

    if user.save
      head :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :country)
  end
end
