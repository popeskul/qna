# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  include DeviseConfiguration

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, notice: exception.message
  end
end
