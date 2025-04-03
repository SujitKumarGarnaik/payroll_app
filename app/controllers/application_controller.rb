class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    elsif resource.employee? 
      employee_dashboard_path
    else
      root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

end
