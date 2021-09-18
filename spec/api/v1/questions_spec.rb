require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].last }
      let!(:answers) { create_list(:answer, 3, author: user, question: question) }

      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API successful authorizable'

      it_behaves_like 'Resource count returnable' do
        let(:resource_response) { json['questions'] }
        let(:resource)          { questions }
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

        it_behaves_like 'Resource count returnable' do
          let(:resource_response) { question_response['answers'] }
          let(:resource)          { answers }
        end

        it_behaves_like 'Returnable public fields' do
          let(:resource_response) { answer_response }
          let(:resource)          { answer }
          let(:fields)            { %w[id body author_id created_at updated_at] }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_files, author: user) }
    let(:question_response) { json['question'] }
    let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API successful authorizable'

      it_behaves_like 'Returnable public fields' do
        let(:resource_response) { question_response }
        let(:resource)          { question }
        let(:fields)            { %w[id title body created_at updated_at] }
      end

      describe 'comments' do
        it_behaves_like 'Resource count returnable' do
          let(:resource_response) { question_response['comments'] }
          let(:resource)          { comments }
        end
      end

      describe 'links' do
        it_behaves_like 'Resource count returnable' do
          let(:resource_response) { question_response['links'] }
          let(:resource)          { links }
        end
      end

      describe 'files' do
        it_behaves_like 'Resource count returnable' do
          let(:resource_response) { question_response['files'] }
          let(:resource)          { question.files }
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:user)     { create(:user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      context 'with valid attributes' do
        let(:params) { { question: attributes_for(:question), access_token: access_token.token } }
        let(:create_question) { post api_path, params: params }

        it 'it saves a new question in database' do
          expect { create_question }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          create_question
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        let(:params) { { question: attributes_for(:question, :invalid), access_token: access_token.token } }
        let(:create_question) { post api_path, params: params }

        it "it doesn't save the question" do
          # byebug
          expect { create_question }.to_not change(Question, :count)
        end

        it 're-render new view' do
          create_question
          expect(response.status).to eq 204
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    let(:params) { { id: question, question: attributes_for(:question), access_token: access_token.token } }
    let(:update_question) { patch api_path, params: params }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'with valid attributes' do
      it 'assigns the requested question to question' do
        update_question
        expect(question).to eq question
      end

      it 'changes question attributes' do
        patch api_path, params: { id: question, question: { body: 'new body' }, access_token: access_token.token }
        question.reload
        expect(question.body).to eq 'new body'
      end

      it 'redirect to updated question' do
        update_question
        expect(response.status).to eq 204
      end
    end

    context 'with invalid attributes' do
      before { update_question }

      it 'does not change question' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyString'
      end

      it 're-renders edit view' do
        expect(response.status).to eq 204
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question) { create(:question, author: user) }
    let(:delete_question) { delete api_path, params: { question_id: question, access_token: access_token.token } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'if answer belongs to the user' do
      it 'successfully delete the question' do
        expect { delete_question }.to change(Question, :count).by(-1)
      end

      it 'successfully redirects to index' do
        delete_question
        expect(response.status).to eq 204
      end
    end

    context 'if answer does not belong to the user' do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:other_question) { create(:question, author: user) }
      let(:other_api_path) { "/api/v1/questions/#{other_question.id}" }
      let(:other_params) { { access_token: access_token.token, question_id: other_question.id } }
      let(:delete_other_question) { delete other_api_path, params: other_params, headers: headers }

      before { delete_other_question }

      it 'can not delete question' do
        expect(Question.count).to eq 1
      end

      it 'redirects to login page' do
        expect(response.status).to eq 204
      end
    end
  end
end
