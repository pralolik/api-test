class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  def is_admin
    if @current_user == nil
      @current_user = AuthorizeApiRequest.call(request.headers).result
    end
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    if @current_user.role.role_type != Role::ADMIN_ROLE
      render json: { error: 'Forbidden' }, status: 403
    end
  end

  def is_teacher
    if @current_user == nil
      @current_user = AuthorizeApiRequest.call(request.headers).result
    end
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    if @current_user.role.role_type != Role::TEACHER_ROLE
      render json: { error: 'Forbidden' }, status: 403
    end
  end

  def is_student
    if @current_user == nil
      @current_user = AuthorizeApiRequest.call(request.headers).result
    end
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    if @current_user.role.role_type != Role::STUDENT_ROLE
      render json: { error: 'Forbidden' }, status: 403
    end
  end
end
