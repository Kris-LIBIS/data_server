class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::StaleObjectError do
    redirect_to resource_path, alert: 'Update failed: data was updated elsewhere while you were editing.'
  end

end
