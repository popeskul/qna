require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user, admin: true) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:params) { { access_token: access_token.token } }
      let(:user_response) { json['user'] }

      before { get api_path, params: params, headers: headers }

      it_behaves_like 'API successful authorizable'

      it_behaves_like 'Returnable public fields' do
        let(:resource_response) { user_response }
        let(:resource)          { me }
        let(:fields)            { %w[id email admin created_at updated_at] }
      end

      it_behaves_like 'Does not returnable private fields' do
        let(:resource) { json }
        let(:fields)   { %w[password encrypted_password] }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      let(:user_response) { json['users'].first }

      before { get api_path, headers: headers, params: { access_token: access_token.token } }

      it_behaves_like 'API successful authorizable'

      it_behaves_like 'Returnable public fields' do
        let(:resource_response) { user_response }
        let(:resource)          { user }
        let(:fields)            { %w[id email admin created_at updated_at] }
      end

      it_behaves_like 'Does not returnable private fields' do
        let(:resource) { json }
        let(:fields)   { %w[password encripted_password] }
      end
    end
  end
end
