class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::StaleObjectError do
    redirect_to resource_path, alert: 'Update failed: data was updated elsewhere while you were editing.'
  end

  def access_denied(exception)
    redirect_to new_admin_user_session_path, alert(exception.message)
  end

end
