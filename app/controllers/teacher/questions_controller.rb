module Teacher
  class QuestionsController < ApplicationController
    before_action :set_question, only: [:show, :update, :destroy]
    before_action :is_teacher

    # GET /questions
    def index
      questions = Question.all

      render json: questions
    end

    # GET /questions/1
    def show
      render json: @question
    end

    # POST /questions
    def create
      question = Question.new(question_params)
      question_type = params[:question_type]
      question_answers = params[:answers]
      if question.save
        if question_type != Question::QUESTION_TYPE_INPUT
          question_answers.each do |answer|
            QuestionSelect.new(select_text: answer[:select_text], is_valid: answer[:is_valid], question_id: question.id).save
          end
        end
        render json: question, status: :created
      else
        render json: question.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /questions/1
    def update
      if @question.update(question_params)
        render json: @question
      else
        render json: @question.errors, status: :unprocessable_entity
      end
    end

    # DELETE /questions/1
    def destroy
      @question.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_question
        @question = Question.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def question_params
        params.require(:question).permit(:question_text,:variant_id, :question_type, :question_point)
      end
  end
end

