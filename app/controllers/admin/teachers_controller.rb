module Admin
  class TeachersController < ApplicationController
    before_action :is_admin

    #GET /admin/teachers
    def index
      users = User.all.joins(:role)
                   .select(:id,:name,:surname,:email)
                   .where('roles.role_type' => Role::TEACHER_ROLE)
                   .order(:id)
      render json: users
    end

    # GET /admin/teachers/:id
    def show
      user = User.all
                  .left_joins(:role)
                  .select(:id,:name,:surname,:email)
                  .order(:id).where('users.id' => params[:id])
                  .where('roles.role_type' => Role::TEACHER_ROLE)
                  .first
      if user
        render json: user, status: :ok
      else
      end
    end

    #GET /admin/teacher/:id/lessons/
    def get_lessons
      user = User.find(params[:id])
      if user.role.role_type != Role::TEACHER_ROLE
        render json: user.errors, status: :unprocessable_entity
        return
      end

      lessons = Lesson.all
                  .joins(:user)
                  .select(:id, :lesson_name, :lesson_type)
                  .order(:id)
                  .where('users.id' => params[:id])

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
  end
end