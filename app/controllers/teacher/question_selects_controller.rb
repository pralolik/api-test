module Teacher
  class QuestionSelectsController < ApplicationController
    before_action :set_question_select, only: [:show, :update, :destroy]
    before_action :is_teacher

    # GET /question_selects
    def index
      @question_selects = QuestionSelect.all

      render json: @question_selects
    end

    # GET /question_selects/1
    def show
      render json: @question_select
    end

    # POST /question_selects
    def create
      @question_select = QuestionSelect.new(question_select_params)

      if @question_select.save
        render json: @question_select, status: :created, location: @question_select
      else
        render json: @question_select.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /question_selects/1
    def update
      if @question_select.update(question_select_params)
        render json: @question_select
      else
        render json: @question_select.errors, status: :unprocessable_entity
      end
    end

    # DELETE /question_selects/1
    def destroy
      @question_select.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_question_select
        @question_select = QuestionSelect.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def question_select_params
        params.require(:question_select).permit(:select_text, :is_valid)
      end
  end
end

