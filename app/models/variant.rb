class Variant < ApplicationRecord
  belongs_to :test
  has_many :question
end
