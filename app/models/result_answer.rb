class ResultAnswer < ApplicationRecord
  belongs_to :result
  belongs_to :question
  belongs_to :question_select
end
