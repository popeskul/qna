# frozen_string_literal: true

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

      before do
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers
      end

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

  describe 'POST /api/v1/questions/:id/answers' do
    let(:user)         { create(:user) }
    let(:question)     { create(:question, author: user) }

    let(:api_path)     { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'with valid attributes' do
      let(:params) { { question_id: question.id, answer: attributes_for(:answer), access_token: access_token.token } }
      let(:request) { post api_path, params: params }

      it_behaves_like 'API successful authorizable' do
        before { request }
      end

      it_behaves_like 'Savable entity' do
        let(:entity) { question.answers.reload }
      end
    end

    context 'with invalid attributes' do
      let(:params) { { question_id: question.id, answer: attributes_for(:answer, :invalid) } }
      let(:create_answer) { post api_path, params: params }

      it_behaves_like 'Does not savable entity' do
        let(:request)  { create_answer }
        let(:entity) { question.answers }
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }

    let!(:question)     { create(:question, author: user) }
    let!(:answer)       { create(:answer, question: question, author: user) }

    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path)     { "/api/v1/answers/#{answer.id}" }

    let(:update_answer) do
      patch api_path, headers: headers, params: {
        id: answer,
        question_id: question.id,
        answer: attributes_for(:answer),
        access_token: access_token.token,
        format: :js
      }
    end

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'if answer belongs to the user' do
      it_behaves_like 'API successful authorizable' do
        before { update_answer }
      end

      it 'assigns the requested answer to @answer' do
        update_answer
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the requested answers question to @question' do
        update_answer
        expect(assigns(:answer).question).to eq question
      end

      it 'changes answer attributes' do
        patch api_path, params: {
          id: answer,
          question_id: question,
          answer: { body: 'new body' },
          access_token: access_token.token
        }

        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        update_answer
        answer.reload
        expect(response.status).to eq 204
      end
    end

    context 'if answer does not belong to the user' do
      let(:other_user)     { create(:user) }
      let(:other_answer)   { create(:answer, question: question, author: other_user) }
      let(:other_api_path) { "/api/v1/answers/#{other_answer.id}" }
      let(:params)         { { access_token: access_token.token, id: other_answer } }

      let(:does_not_delete_answer) { delete other_api_path, headers: headers, params: params }

      it 'does not change answer attributes' do
        does_not_delete_answer
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user) }

    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path)     { "/api/v1/answers/#{answer.id}" }

    let(:delete_answer) do
      delete api_path, headers: headers, params: { id: answer, question_id: question, access_token: access_token.token }
    end

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'if answer belongs to the user', js: true do
      it_behaves_like 'API successful authorizable' do
        before { delete_answer }
      end

      it 'deletes answer' do
        expect { delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'render view destroy' do
        delete_answer
        expect(response.status).to eq 204
      end
    end

    context 'if answer does not belong to the user' do
      let(:other_user) { create(:user) }
      let!(:other_question) { create(:question, author: other_user) }
      let!(:other_answer) { create(:answer, question: other_question, author: other_user) }
      let(:api_path) { "/api/v1/answers/#{other_answer.id}" }
      let(:params) { { access_token: access_token.token, id: other_answer, question_id: other_question, format: :js } }

      let(:does_not_delete_answer) { delete api_path, headers: headers, params: params }

      it 'does not delete answer' do
        expect { does_not_delete_answer }.to_not change(Answer, :count)
      end

      it 'redirects to question#show' do
        does_not_delete_answer
        expect(response).to_not redirect_to question
      end
    end
  end
end
