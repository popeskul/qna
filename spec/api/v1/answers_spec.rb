require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user)     { create(:user) }
    let(:question) { create(:question, author: user) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question, author: user) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API successful authorizable'

      it_behaves_like 'Resource count returnable' do
        let(:resource_response) { json['answers'] }
        let(:resource)          { answers }
      end

      it_behaves_like 'Returnable public fields' do
        let(:resource_response) { json['answers'].first }
        let(:resource)          { answers.first }
        let(:fields)            { %w[id body created_at updated_at question_id author_id best] }
      end
    end
  end
end
