class Role < ApplicationRecord
  belongs_to :user
  ADMIN_ROLE = 'ADMIN'
  TEACHER_ROLE = 'TEACHER'
  STUDENT_ROLE = 'STUDENT'
  UNDEFINED_ROLE = 'UNDEFINED'

end
