class QuestionSelect < ApplicationRecord
  belongs_to :question
  has_many :result_answers
end
