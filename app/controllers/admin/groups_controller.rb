module Admin
  class GroupsController < ApplicationController
    before_action :set_group, only: [:show, :update, :destroy]
    before_action :is_admin

    # GET /admin/groups
    def index
      groups = Group.all

      render json: groups
    end

    # GET /groups/1
    def show
      render json: @group
    end

    # POST /groups
    def create
      group = Group.new(group_params)
      if group.save
        group = Group.all.where('groups.id' => group.id).select(:id,:group_type,:group_number)
        render json: group, status: :created
      else
        render json: group.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /groups/1
    def update
      if @group.update(group_params)
        render json: @group
      else
        render json: @group.errors, status: :unprocessable_entity
      end
    end

    # DELETE /groups/1
    def destroy
      @group.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.all.where('groups.id' => params[:id]).select(:id,:group_type,:group_number).first
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:group_type, :group_number, :year_of_receipt)
    end
  end
end
