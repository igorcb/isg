class User < ApplicationRecord
  EMAIL_REGEX = /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/

  has_secure_password
  
  validates :name, presence: true
  validates :email, presence: true, format: { with: EMAIL_REGEX }
  validates_confirmation_of :password
  validates_presence_of :password_confirmation, if: -> { new_record? || !password.nil? }
  validates :password, presence: true, 
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
  
  has_many :posts
end
