require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }
      subject { post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js } }

      it 'save a new answer' do
        expect { subject }.to change { question.answers.reload.count }.by(1)
      end

      it 'redirects to show' do
        subject
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user2) }
      let(:answer) { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid), format: :js } }

      it 'does not save the new answer in the database' do
        expect { answer }.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        answer
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }
    let(:delete_answer) { delete :destroy, params: { id: answer, question_id: question } }

    context 'if answer belongs to the user' do
      before { login(answer.author) }

      it 'deletes answer' do
        expect { delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show' do
        delete_answer
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'if answer does not belong to the user' do
      let!(:user) { create(:user) }

      before { sign_in(user) }

      it 'does not delete answer' do
        expect { delete_answer }.to_not change(Answer, :count)
      end

      it 'redirects to question#show' do
        delete_answer
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question) }
    let(:update) { patch :update, params: { id: answer, question_id: question.id, answer: attributes_for(:answer), format: :js } }
    let(:another_user) { create :user }

    context 'if answer belongs to the user' do
      before { sign_in(answer.author) }

      it 'assigns the requested answer to @answer' do
        update
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the requested answers question to @question' do
        update
        expect(assigns(:answer).question).to eq question
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'} }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        update
        answer.reload
        expect(response).to render_template(:update)
      end
    end

    context 'if answer does not belong to the user' do
      before { sign_in(another_user) }

      it 'does not change answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'} }, format: :js
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end
  end
end
