# frozen_string_literal: true

# FindForOauthService service
class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    return @authorization.user if authorization(auth)

    email = auth.info[:email]
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    user.create_authorization(auth) && user
  end

  private

  def authorization(auth)
    @authorization ||= Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
  end
end
