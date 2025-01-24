module ConnectionsHelper
  def update_button(connection)
    if connection.status == "accepted"
      link_to connection.status.titleize, "javascript:void(0)", class: "btn btn-success mt-2"
    elsif connection.status == "rejected"
      link_to connection.status.titleize, "javascript:void(0)", class: "btn btn-danger mt-2"
    else
      link_to connection.status.titleize, "javascript:void(0)", class: "btn btn-primary mt-2"
    end
  end

  def mutual_connection_count(user, user_)
    if current_user != user_
      current_user.mutually_connected_ids(user_).count
    else
      current_user.mutually_connected_ids(user).count
    end
  end
end
