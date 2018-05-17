class Question < ApplicationRecord
  belongs_to :variant
  has_many :question_select

  QUESTION_TYPE_INPUT = 'INPUT'
  QUESTION_TYPE_SELECT = 'INPUT'
  QUESTION_TYPE_MULTISELECT = 'INPUT'
end
