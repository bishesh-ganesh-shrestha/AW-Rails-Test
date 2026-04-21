# Represents a user of the system
#
# @!attribute first_name
#   @return [String]
# @!attribute last_name
#   @return [String]
# @!attribute email
#   @return [String]
class User < ApplicationRecord
  has_secure_password

  before_save { email.downcase! }

  has_many :contents, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }

  # Returns full name of the user
  #
  # @return [String]
  def full_name
    "#{first_name} #{last_name}"
  end
end
