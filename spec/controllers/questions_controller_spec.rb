# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'it populates an array of all questions' do
      expect(questions).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'it saves a new question in database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it "it doesn't save the question" do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(question).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to eq 'new body'
      end

      it 'redirect to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template(:update)
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }

      it 'does not change question' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyString'
      end

      it 're-renders edit view' do
        expect(response).to render_template(:update)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user2) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:delete_question) { delete :destroy, params: { id: question } }

    context 'if answer belongs to the user' do
      before { login(user) }

      it 'successfully delete the question' do
        expect { delete_question }.to change(Question, :count).by(-1)
      end

      it 'successfully redirects to index' do
        delete_question
        expect(response).to redirect_to questions_path
      end
    end

    context 'if answer does not belong to the user' do
      context 'authenticated user' do
        before { login(user2) }

        it 'con not delete another question' do
          expect { delete_question }.to_not change(Question, :count)
        end

        it 'redirects to question#show' do
          delete_question
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'not authenticated user' do
        it 'con not delete another question' do
          expect { delete_question }.to_not change(Question, :count)
        end

        it 'redirects to login page' do
          delete_question
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
