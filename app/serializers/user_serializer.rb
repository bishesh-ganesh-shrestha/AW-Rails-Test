class UserSerializer
  include JSONAPI::Serializer

  set_type :users

  attribute :token do |_user, params|
    params[:token]
  end

  attribute :email

  attribute :name do |user|
    user.full_name
  end

  attributes :country, :created_at, :updated_at
end
