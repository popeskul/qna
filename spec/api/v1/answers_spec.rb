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

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }

    let(:question) { create(:question, :with_files, author: user) }
    let(:answer) { create(:answer, :with_files, author: user) }
    let(:answer_response) { json['answer'] }

    let!(:comments) { create_list(:comment, 2, commentable: answer, user: user) }
    let!(:links) { create_list(:link, 2, linkable: answer) }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API successful authorizable'

      it_behaves_like 'Returnable public fields' do
        let(:resource_response) { answer_response }
        let(:resource)          { answer }
        let(:fields)            { %w[id body created_at updated_at] }
      end

      describe 'comments' do
        it_behaves_like 'Resource count returnable' do
          let(:resource_response) { answer_response['comments'] }
          let(:resource)          { comments }
        end
      end

      describe 'links' do
        it_behaves_like 'Resource count returnable' do
          let(:resource_response) { answer_response['links'] }
          let(:resource)          { links }
        end
      end

      describe 'files' do
        it_behaves_like 'Resource count returnable' do
          let(:resource_response) { answer_response['files'] }
          let(:resource)          { answer.files }
        end
      end
    end
  end
end
