class MembersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit_description update_description edit_personal_details update_personal_details]

  def show
    @user = User.find(params[:id])
  end

  def edit_description
  end

  def update_description
    respond_to do |format|
      if current_user.update(user_about_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("member_description", partial: "members/member_description", locals: { user: current_user }) }
      end
    end
  end

  def edit_personal_details
  end

  def update_personal_details
    respond_to do |format|
      if current_user.update(user_personal_info_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("member_personal_details", partial: "members/member_personal_details", locals: { user: current_user }) }
      end
    end
  end

  private

  def user_about_params
    params.require(:user).permit(:about)
  end

  def user_personal_info_params
    params.require(:user).permit(
      :first_name, :last_name, :date_of_birth, :username, :city, :state, :country, :pincode, :street_address, :profile_title, :about, :contact_number
    )
  end
end
