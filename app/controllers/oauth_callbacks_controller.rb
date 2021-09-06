# frozen_string_literal: true

# OauthCallbacksController
class OauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth(:google_oauth2)
  end

  def github
    auth(:github)
  end

  def facebook
    auth(:facebook)
  end

  def auth(type)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: type) if is_navigational_format?
    else
      redirect_to root_path, notice: t('errors.messages.bad_auth', auth_name: 'Github')
    end
  end
end
