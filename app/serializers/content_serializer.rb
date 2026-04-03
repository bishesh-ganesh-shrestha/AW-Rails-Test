class ContentSerializer
  include JSONAPI::Serializer

  attributes :title, :body, :created_at, :updated_at
end
