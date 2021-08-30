require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }

  let(:create_question_comments) { post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js } }
  let(:create_answer_comments) { post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), format: :js } }

  describe 'POST #create' do
    describe 'with authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'save comment for question in database' do
          expect { create_question_comments }.to change(question.comments, :count).by(1)
        end

        it 'save comment for answer in database' do
          expect { create_answer_comments }.to change(answer.comments, :count).by(1)
        end

        it 'new comment has owner' do
          create_question_comments
          expect(assigns(:comment).user).to eq user
        end

        it 'renders create template ' do
          create_question_comments
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        subject do
          post :create, params: { question_id: question.id, comment: attributes_for(:comment, :invalid), format: :js }
        end

        it 'not save answer in database' do
          expect { subject }.to_not change(question.comments, :count)
        end

        it 're-render create template' do
          subject
          expect(response).to render_template :create
        end
      end
    end

    context 'Unauthenticated user' do
      it 'tries create comment' do
        expect { create_question_comments }.to_not change(question.comments, :count)
      end

      it 're-render login page' do
        create_question_comments
        expect(response.body).to eql 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
