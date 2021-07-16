require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:answer) { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }

      it 'save a new answer in the database' do
        expect { answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show' do
        answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      let(:answer) { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }

      it 'does not save the new answer in the database' do
        expect { answer }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        answer
        expect(response).to render_template :new
      end
    end
  end
end
