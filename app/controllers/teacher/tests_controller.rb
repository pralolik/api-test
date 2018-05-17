module Teacher
  class TestsController < ApplicationController
  before_action :set_test, only: [:show, :update, :destroy]
  before_action :is_teacher

  # GET /tests
  def index
    @tests = Test.all

    render json: @tests
  end

  # GET /tests/1
  def show
    render json: @test
  end

  # POST /tests
  def create
    @test = Test.new(test_params)
    @test_variants_type = params[:type_of_variant]
    @test_variants_count = params[:variants_count]
    if @test.save
      if @test_variants_type != Test::VARIANT_TYPE_ONE
        for i in 1..@test_variants_count
          @new_variant = Variant.new(variant_text: "Вариант#{i}", test_id: @test.id)
          @new_variant.save
        end
      elsif @test_variants_type == Test::VARIANT_TYPE_ONE
        @new_variant = Variant.new(variant_text: 'Вариант1', test_id: @test.id)
        @new_variant.save
      end
      render json: @test, status: :created
    else
      render json: @test.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tests/1
  def update
    if @test.update(test_params)
      render json: @test
    else
      render json: @test.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tests/1
  def destroy
    @test.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test
      @test = Test.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def test_params
      params.require(:test).permit(:test_name,:lesson_id, :is_active, :type_of_variant, :variants_count, :due_date)
    end
  end
end

