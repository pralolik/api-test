module Admin
  class StudentsController < ApplicationController
    before_action :is_admin

    #GET /admin/students
    def index
      @users = User.all.left_joins(:group,:role)
                   .select(:id,:name,:surname,:email,:group_number)
                   .where('roles.role_type' => Role::STUDENT_ROLE)
                   .order(:id)
      render json: @users
    end

    # GET /admin/students/:id
    def show
      @user = User.all
                  .left_joins(:group,:role)
                  .select(:id,:name,:surname,:email,:group_number)
                  .where('roles.role_type' => Role::STUDENT_ROLE)
                  .order(:id).where('users.id' => params[:id]).first
      if @user
        render json: @user, status: :ok
      else
      end
    end

    # GET /admin/students/flow/:flow
    def flow
      @users = User.all
                   .left_joins(:group,:role)
                   .select(:id,:name,:surname,:email,:group_number)
                   .order(:id)
                   .where('groups.group_type' => params[:flow])
                   .where('roles.role_type' => Role::STUDENT_ROLE)
      if @users
        render json: @users, status: :ok
      else
      end
    end

    # GET /admin/students/group/:group
    def group
      @users = User.all
                   .left_joins(:group)
                   .select(:id,:name,:surname,:email,:group_number)
                   .order(:id)
                   .where('groups.group_number' => params[:group])
                   .where('roles.role_type' => Role::STUDENT_ROLE)

      render json: @users, status: :ok
    end

    #GET /admin/students/:id/lessons
    def lessons
      @user = User.all
                  .left_joins(:group)
                  .select(:id,:name,:surname,:email,:group_number)
                  .order(:id)
                  .where('users.id' => params[:id]).first
      if @user
        @lessons = Lesson.all.left_joins(:group, :user)
                       .where('groups.id' => @user.group.first.id).select(:id,:lesson_name,:lesson_type,:name,:surname)

        render json:@lessons
      else

      end

    end

    #PUT/PATCH /admin/students/:id/group/
    def set_group
      @user = User.all
                  .left_joins(:group)
                  .select(:id,:name,:surname,:email,:group_number)
                  .order(:id)
                  .where('users.id' => params[:id]).first

      @group = Group.find_by group_number: params[:group]
      if @user != nil and @group != nil and @user.role.role_type == Role::STUDENT_ROLE
        begin
          if @user.group.first
            @user.group.delete(@user.group.first)
          end
          @user.group << @group
          @user.group_number = @group.group_number
          render json: @user
        rescue => ex
          render json: {errors: ['Sorry we will back soon']}, status: :internal_server_error
        end
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    #DELETE /admin/students/:id/group/
    def delete_group
      @user = User.all
                  .left_joins(:group,:role)
                  .select(:id,:name,:surname,:email,:group_number)
                  .order(:id).where('users.id' => params[:id]).first

      if @user != nil and @user.role.role_type == Role::STUDENT_ROLE
        begin
          if @user.group.first
            @user.group.delete(@user.group.first)
            @user.group_number = nil
            render json: @user
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        rescue => ex
          render json: {errors: ['Sorry we will back soon']}, status: :internal_server_error
        end
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

  end
end