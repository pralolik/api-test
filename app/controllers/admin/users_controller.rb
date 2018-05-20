module Admin
  class UsersController < ApplicationController
    before_action :is_admin
    before_action :set_user, only: [:show, :update, :destroy]
    #GET /admin/users
    def index
      users = User.all.left_joins(:group,:role)
                   .select(:id,:name,:surname,:email,:group_number,:role_type)
                   .where('roles.role_type' => Role::UNDEFINED_ROLE)
                   .order(:id)
      render json: users
    end

    # GET /admin/users/:id
    def show
      if user
        render json: user, status: :ok
      else
      end
    end

    #POST /admin/users/
    def create
      command = RegisterUser.call(params)

      if command.success?
        render json: { message:"success" },status: :ok
      else
        render json: { error: command.errors }, status: :unauthorized
      end
    end

    #PUT/PATCH /admin/users/:id/role/:role_name
    def set_role
      user = User.all
                  .left_joins(:group,:role)
                  .select(:id,:name,:surname,:email,:role_type)
                  .order(:id)
                  .where('users.id' => params[:id])
                  .where('roles.role_type' => Role::UNDEFINED_ROLE)
                  .first
      if user
        user.role.role_type = params[:role_name]
        user.role.save
        user.role_type = params[:role_name]
        render json: user, status: :ok
      else
      end
    end

    # PATCH/PUT /admin/users/:id
    def update
      if @user.update(user_params)
        @user = set_user
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /admin/users/:id
    def destroy
      @user.destroy
    end

    private

    def set_user
      @user = User.all
                  .left_joins(:group,:role)
                  .select(:id,:name,:surname,:email,:group_number,:role_type)
                  .order(:id)
                  .where('users.id' => params[:id])
                  .first
    end

    def user_params
      params.require(:user).permit(:name, :surname,:email)
    end

  end
end
