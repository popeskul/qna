# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let(:oauth_data) { { 'provider' => 'github', 'uid' => 123 } }

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'Github' do
    include_examples 'social-testing', :github
  end

  describe 'Google' do
    include_examples 'social-testing', :google_oauth2
  end

  describe 'Facebook' do
    include_examples 'social-testing', :facebook
  end
end
