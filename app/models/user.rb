class User < ApplicationRecord
  has_secure_password
  has_one :role, dependent: :delete
  has_many :lesson, dependent: :delete_all
  has_and_belongs_to_many :group, dependent: :delete
end
