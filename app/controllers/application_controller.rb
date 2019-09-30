# noinspection RubyResolve
class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::StaleObjectError do
    redirect_to back_path, alert: 'Update failed: data was updated elsewhere while you were editing.'
  end

end
