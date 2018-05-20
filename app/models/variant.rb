class Variant < ApplicationRecord
  belongs_to :test
  has_many :question
  has_many :result
end
