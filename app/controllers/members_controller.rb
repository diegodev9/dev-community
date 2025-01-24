class MembersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @connections = Connection.where("user_id = ? OR connected_user_id = ?", @user.id, @user.id).where(status: "accepted")
    @mutual_connections = current_user.mutually_connected_ids(@user)
  end

  def edit_description
  end

  def update_description
    if current_user.update(user_about_params)
      render_turbo_stream(
        "replace",
        "member_description",
        "members/member_description",
        { user: current_user }
      )
    end
  end

  def edit_personal_details
  end

  def update_personal_details
    if current_user.update(user_personal_info_params)
      render_turbo_stream(
        "replace",
        "member_personal_details",
        "members/member_personal_details",
        { user: current_user }
      )
    end
  end

  def connections
    @user = User.find(params[:id])
    total_users = if params[:mutual_connections].present?
                    User.where(id: current_user.mutually_connected_ids(@user))
                  else
                    User.where(id: @user.connected_user_ids)
                  end
    @connected_users = total_users.page(params[:page]).per(2)
    @total_connections = total_users.count
  end

  private

  def user_about_params
    params.permit(user: [ :about ]).require(:user)
  end

  def user_personal_info_params
    params.permit(user: [
      :first_name, :last_name, :date_of_birth, :username, :city, :state, :country, :pincode, :street_address, :profile_title, :about, :contact_number
    ]
    ).require(:user)
  end
end
