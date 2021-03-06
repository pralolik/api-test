class StudentController < ApplicationController
  before_action :is_student

  #GET /student
  def index
    render json:  @current_user
  end

  #GET /student/lessons
  def show_lessons
    if current_user
      lessons = Lesson.all.left_joins(:group, :user)
                     .where('groups.id' => @current_user.group.first.id).select(:id,:lesson_name,:lesson_type,:name,:surname)

      render json:lessons
    else
    end
  end

  #GET /student/lessons/:id
  def lesson_details
    lesson = Lesson.all
                  .joins(:user)
                  .select(:id, :lesson_name, :lesson_type)
                  .order(:id)
                  .where('lessons.id' => params[:id])
                  .first

    if lesson != nil
      lessonArray = lesson.attributes
      lessonGroups = Group.all.joins(:lesson).select(:id, :group_number).where('lessons.id' => lesson.id)
      lessonTests = Test.all.joins(:lesson).select(:id, :test_name).where('lessons.id' => lesson.id)
      lessonArray[:lesson_groups] = lessonGroups
      lessonArray[:lesson_tests] = lessonTests
      render json:  lessonArray
    else
      render json: lesson.errors, status: :unprocessable_entity
    end
  end

  #GET /student/tests
  def get_tests
    lessons = Lesson.all.left_joins(:group, :user)
                  .where('groups.id' => @current_user.group.first.id).select(:id,:lesson_name,:lesson_type,:name,:surname)
    tests = Test.all.left_joins(:lesson).where('tests.lesson_id' => lessons.ids, 'lessons.id' => lessons.ids)
                .select(:id, :test_name, :due_date, :lesson_name)

    render json: tests
  end

  #GET /student/test/:id
  def start_test
    result = Result.all.where('results.user_id' => @current_user.id).first
    if result and result.end_date == nil
      render json: result.tmp_json
      return
    elsif result and result.end_date != nil
      render json: ['error'=>'You already pass this test']
      return
    end
    variant = get_variant
    tmp_json = get_json(variant).to_json
    result = Result.new(variant_id:variant.id, user_id:@current_user.id, tmp_json:tmp_json)
     if result.save
       render json: tmp_json
     end
  end


  def get_variant
    current_test = Test.all.where('tests.is_active'=> true, 'tests.id' => params[:id]).first
    if current_test.type_of_variant == Test::VARIANT_TYPE_ONE
      return current_test.variant.first
    elsif current_test.type_of_variant == Test::VARIANT_TYPE_RANDOM
      return current_test.variant[rand(current_test.variants_count)]
    elsif current_test.type_of_variant == Test::VARIANT_TYPE_SORTED
      return sorted_variant(current_test)
    end
  end

  def get_json(variant)
    questions = Question.all.joins(:variant).where('questions.variant_id' => variant.id)
                    .select(:id, :question_text,:question_type)
    current_variant = variant.attributes
    current_questions = []
    questions.each do |question|
      if question.question_type == Question::QUESTION_TYPE_SELECT
        current_questions.push(get_select_question_json(question))
      elsif question.question_type == Question::QUESTION_TYPE_MULTISELECT
        current_questions.push(get_multiselect_question_json(question))
      elsif question.question_type == Question::QUESTION_TYPE_INPUT
        current_questions.push(get_input_question_json(question))
      end
    end
    current_variant[:questions] = current_questions

    return current_variant
  end

  def get_select_question_json(question)
    current_question = question.attributes
    question_answers = QuestionSelect.all.where('question_selects.question_id' => question.id)
                           .select(:id, :select_text)
    current_question[:answers] = question_answers
    current_question[:selected_answer] = nil

    return current_question
  end

  def get_multiselect_question_json(question)
    current_question = question.attributes
    question_answers = QuestionSelect.all.where('question_selects.question_id' => question.id)
                           .select(:id, :select_text)
    current_question[:answers] = question_answers
    current_question[:selected_answer] = nil

    return current_question
  end

  def get_input_question_json(question)
    current_question = question.attributes
    current_question[:text_answer] = nil

    return current_question
  end

  def sorted_variant(test)
    users = User.all
                .left_joins(:group, :role)
                .where('groups.id' => @current_user.group.first.id)
                .where('roles.role_type' => Role::STUDENT_ROLE)
                .order(:surname)
                .order(:name)

    student_number = users.to_a.map(&:surname).index(current_user.surname)
    student_number = student_number + 1
    variant_number = student_number - (student_number/test.variants_count).floor * test.variants_count
    test.variant[variant_number]
  end

  #PUT /student/test/update/:variant_id
  def update_test
    result = Result.all.where('results.user_id' => @current_user.id, 'results.variant_id' => params[:variant_id]).first
    if result and result.end_date == nil
      params.delete :student
      params.delete :action
      params.delete :controller
      params.delete :variant_id
      result_tmp = params.to_json
      result.tmp_json = result_tmp
      if result.save
        render json: result.tmp_json
      end
      return
    elsif result and result.end_date != nil
      render json: ['error'=>'You already pass this test']
      return
    end
  end

  #POST /student/test/end/:variant_id
  def end_test
    result = Result.all.where('results.user_id' => @current_user.id).first
    if result and result.end_date == nil
      result.tmp_json = params.to_json
      result.end_date = Date.today.to_s
      result.require_check = get_require_check(params[:questions])
      if result.save
         if save_results(result)
           render json: ['success' => 'Test result saved']
         end
      end
        render json: ['error' => 'Error with your answers']
      return
    elsif result and result.end_date != nil
      render json: ['error'=>'You already pass this test']
      return
    end
  end

  def get_require_check(questions)
    require = false

    questions.each do |question|
      if question[:question_type] == Question::QUESTION_TYPE_INPUT
        require = true
      end
    end

    return require
  end

  def save_results(result)
    params[:questions].each do |question|
      if question[:question_type] == Question::QUESTION_TYPE_SELECT
        question_selects = QuestionSelect.all.where('question_selects.question_id' => question[:id], 'question_selects.is_valid' => true)
        valid = validate(question_selects, question[:selected_answer])
        question_result = ResultAnswer.new(user_id: @current_user.id,
                                           result_id: result.id,
                                           question_id: question[:id],
                                           question_select_id: question[:selected_answer].to_s,
                                           is_checked: true,
                                           is_valid: valid)

      elsif question[:question_type] == Question::QUESTION_TYPE_MULTISELECT
        question_selects = QuestionSelect.all.where('question_selects.question_id' => question[:id], 'question_selects.is_valid' => true)
        valid = validate(question_selects, question[:selected_answer])
        question_result = ResultAnswer.new(user_id: @current_user.id,
                                           result_id: result.id,
                                           question_id: question[:id],
                                           question_select_id: question[:selected_answer].to_s,
                                           is_checked: true,
                                           is_valid: valid)
      elsif question[:question_type] == Question::QUESTION_TYPE_INPUT
        question_result = ResultAnswer.new(user_id: @current_user.id,
                                           result_id: result.id,
                                           question_id: question[:id],
                                           question_answer_text: question[:text_answer],
                                           is_checked: false,
                                           is_valid: false)
      end
      if !question_result.save
        break
      end
    end
  end

  def validate (selects, selected)
    if selects.length != selected.length
      return false
    end
    valid = true
    selects.each do |valid_answer|
      finded = false
      selected.each do |result_answer|
        if valid_answer.id == result_answer
          finded = true
        end
      end
      if finded == false
        valid = false
      end
    end

    return valid
  end

end