require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:api_path) { '/api/v1/questions' }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].last }
      let!(:answers) { create_list(:answer, 3, author: user, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API successful authorizable'

      it 'returns list of questions' do
        expect(json['questions'].count).to eq 2
      end

      it_behaves_like 'Returnable public fields' do
        let(:resource_response) { question_response }
        let(:resource)          { question }
        let(:fields)            { %w[id title body created_at updated_at] }
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer)          { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it_behaves_like 'Returnable public fields' do
          let(:resource_response) { answer_response }
          let(:resource)          { answer }
          let(:fields)            { %w[id body author_id created_at updated_at] }
        end
      end
    end
  end
end
