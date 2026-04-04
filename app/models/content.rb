# Represents content created by a user
#
# @!attribute title
#   @return [String] title of the content
# @!attribute body
#   @return [String] body of the content
# @!attribute user_id
#   @return [Integer] owner user ID
class Content < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
end
