class Lesson < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :group
  has_many :test

  LESSON_TYPE_FLOW = 'FLOW'
  LESSON_TYPE_PRACTICE = 'PRACTISE'
  LESSON_TYPE_LABS = 'LABS'
  attr_accessor :lesson_groups

end
