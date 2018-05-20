class LessonMarksResult < ApplicationRecord
  belongs_to :user
  belongs_to :lesson_mark
end
