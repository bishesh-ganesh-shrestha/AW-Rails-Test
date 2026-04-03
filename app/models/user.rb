class User < ApplicationRecord
  has_secure_password

  has_many :contents, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
