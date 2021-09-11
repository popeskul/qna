# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }

  let!(:question) { create(:question, author: user1) }
  let!(:link) { create(:link, linkable: question) }

  let(:delete_link) { delete :destroy, params: { id: link }, format: :js }

  describe 'DELETE #destroy' do
    context 'Authorized user delete link' do
      before { login(user1) }

      it 'delete link' do
        expect { delete_link }.to change(question.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authorized user tries to delete link' do
      before { login(user) }

      it 'user tries to delete not his link' do
        expect { delete_link }.to_not change(question.links, :count)
      end

      it 'renders destroy view' do
        expect { delete_link }.to_not change(question.links, :count)
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete link' do
        expect { delete_link }.to_not change(question.links, :count)
      end

      it 'redirects to new session view' do
        delete :destroy, params: { id: link }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
