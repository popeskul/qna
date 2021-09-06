# frozen_string_literal: true

require 'rails_helper'

# Partial for social testing
RSpec.shared_context 'social-testing' do |type|
  it 'finds user from oauth data' do
    # allow - interceptor
    allow(request.env).to receive(:[]).and_call_original # default call if no arguments
    allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    expect(User).to receive(:find_for_oauth).with(oauth_data)
    get type
  end

  context 'user exists' do
    let!(:user) { create(:user) }

    before do
      allow(User).to receive(:find_for_oauth).and_return(user)
      get type
    end

    it 'login user' do
      expect(subject.current_user).to eq user
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end

  context 'user does not exist' do
    before do
      allow(User).to receive(:find_for_oauth)
      get type
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end

    it 'does not login user' do
      expect(subject.current_user).to_not be
    end
  end
end
