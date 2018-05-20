class TeacherController < ApplicationController
  before_action :is_teacher

  #GET /teachers
  def index
    render json:  @current_user
  end

  #GET /teachers/lessons
  def show_lessons
     lessons = Lesson.all
                   .joins(:user)
                   .select(:id, :lesson_name, :lesson_type)
                   .order(:id)
                   .where('users.id' => @current_user.id)

    if lessons != nil
      lessonsArray = []
      lessons.each do |lesson|
        lessonGroups = Group.all.joins(:lesson).select(:id, :group_number).where('lessons.id' => lesson.id)
        lesson.lesson_groups = lessonGroups
        currentLesson = lesson.attributes
        currentLesson[:lesson_groups] = lessonGroups
        lessonsArray.push(currentLesson)
      end
      render json:  lessonsArray
    else
      render json: lessons.errors, status: :unprocessable_entity
    end
  end

  #GET teacher/lessons/:id
  def lesson_details
    lesson = Lesson.all
                   .joins(:user)
                   .select(:id, :lesson_name, :lesson_type)
                   .order(:id)
                   .where('users.id' => @current_user.id, 'lessons.id' => params[:id])
                   .first

    if lesson != nil
      lessonArray = @lesson.attributes
      lessonGroups = Group.all.joins(:lesson).select(:id, :group_number).where('lessons.id' => lesson.id)
      lessonTests = Test.all.joins(:lesson).select(:id, :test_name).where('lessons.id' => lesson.id)
      lessonArray[:lesson_groups] = lessonGroups
      lessonArray[:lesson_tests] = lessonTests
      render json:  lessonArray
    else
      render json: lesson.errors, status: :unprocessable_entity
    end
  end

end