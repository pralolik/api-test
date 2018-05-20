class Question < ApplicationRecord
  belongs_to :variant
  has_many :question_select
  has_many :result_answers

  QUESTION_TYPE_INPUT = 'INPUT'
  QUESTION_TYPE_SELECT = 'SELECT'
  QUESTION_TYPE_MULTISELECT = 'MULTISELECT'
end
