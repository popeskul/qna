# frozen_string_literal: true

# DeviseConfiguration
module DeviseConfiguration
  def self.included(base)
    base.send(:before_action, :configure_permitted_parameters, if: :devise_controller?)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation, :admin)
    end
  end
end
