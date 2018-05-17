class Test < ApplicationRecord
  belongs_to :lesson
  has_many :variant

  VARIANT_TYPE_ONE = 'ONE'
  VARIANT_TYPE_SORTED = 'SORTED'
  VARIANT_TYPE_RANDOM = 'RANDOM'
end

