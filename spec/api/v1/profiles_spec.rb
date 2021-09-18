require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:api_path) { '/api/v1/profiles/me' }

  describe 'GET /api/v1/profiles/me' do
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
end
