class MembersController < ApplicationController
  before_action :set_user, only: %i[show edit_description]

  def show
  end

  def edit_description
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end