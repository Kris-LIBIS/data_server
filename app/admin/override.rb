ActiveAdmin::Devise::SessionsController.class_eval do
  def after_sign_in_path_for(resource)
    admin_dashboard_path
  end

  def root_path
    "/admin/login"  #add your logic
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def destroy
    super do
      redirect_to '/admin/login'
    end
  end
end
