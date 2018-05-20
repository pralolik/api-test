module Admin
  class LessonsController < ApplicationController
    before_action :set_lesson, only: [:show, :update, :destroy]
    before_action :is_admin

    # GET /lessons
    def index
      lessons = Lesson.all.joins(:user).select(:id,:lesson_name,:lesson_type,:name,:surname)
      lessonsArray = []
      lessons.each do |lesson|
        lessonGroups = Group.all.joins(:lesson).select(:id, :group_number).where('lessons.id' => lesson.id)
        lesson.lesson_groups = lessonGroups
        currentLesson = lesson.attributes
        currentLesson[:lesson_groups] = lessonGroups
        lessonsArray.push(currentLesson)
      end
      render json:  lessonsArray
    end

    # GET /lessons/1
    def show
      render json: @lesson
    end

    # POST /lessons
    def create
      lesson_parameters = lesson_params
      lesson = Lesson.new(lesson_params)
      lesson_flow = params[:lesson_flow]
      lesson_groups = params[:lesson_groups]

      if lesson.save
       # begin
          if lesson_parameters[:lesson_type] == Lesson::LESSON_TYPE_FLOW
            groups = Group.all.where('groups.group_type' => lesson_flow).select(:id,:group_number)
          else
            groups = Group.all.where('groups.group_number' => lesson_groups).select(:id,:group_number)
          end
          lesson.group << groups
          lesson = Lesson.all
                          .joins(:user)
                         .select(:id, :lesson_name, :lesson_type, :name, :surname)
                         .order(:id)
                         .where('lessons.id' => lesson.id).first
          current_lesson = lesson.attributes
          current_lesson[:lesson_groups] = groups
          render json: current_lesson, status: :created
        # rescue => ex
        #
        # end
      else
        render json: lesson.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /lessons/1
    def update
      if @lesson.update(lesson_params)
        render json: @lesson
      else
        render json: @lesson.errors, status: :unprocessable_entity
      end
    end

    # DELETE /lessons/1
    def destroy
      @lesson.destroy
    end

    private

    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    def lesson_params
      params.require(:lesson).permit(:lesson_name, :lesson_type, :user_id)
    end
  end
end