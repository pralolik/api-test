module Teacher
  class VariantsController < ApplicationController
    before_action :set_variant, only: [:show, :update, :destroy]
    before_action :is_teacher

    # GET /variants
    def index
      variants = Variant.all

      render json: variants
    end

    # GET /variants/1
    def show
      variant = Variant.find(params[:id])
      questions = Question.all.joins(:variant).where('questions.variant_id' => variant.id)
      current_variant = variant.attributes
      current_questions = []
      questions.each do |question|
        if question.question_type != Question::QUESTION_TYPE_INPUT
          question_answers = QuestionSelect.all.where('question_selects.question_id' => question.id)
          current_question = question.attributes
          current_question[:answers] = question_answers
          current_questions.push(current_question)
        elsif question.question_type == Question::QUESTION_TYPE_INPUT
          current_questions.push(question.attributes)
        end
      end
      current_variant[:questions] = current_questions
      render json: current_variant
    end

    # POST /variants
    def create
      variant = Variant.new(variant_params)

      if variant.save
        render json: variant, status: :created, location: @variant
      else
        render json: variant.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /variants/1
    def update
      if @variant.update(variant_params)
        render json: @variant
      else
        render json: @variant.errors, status: :unprocessable_entity
      end
    end

    # DELETE /variants/1
    def destroy
      @variant.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_variant
      @variant = Variant.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def variant_params
      params.require(:variant).permit(:variant_text)
    end
  end
end