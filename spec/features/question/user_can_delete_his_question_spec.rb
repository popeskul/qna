require 'rails_helper'

feature 'User can delete his question' do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }

  describe 'Authenticated user' do
    background { sign_in(user) }
    let(:question) { create(:question, author: user) }

    scenario 'Authenticated user can delete his question' do
      visit question_path(question)

      expect(page).to have_content question.body
      expect(page).to have_content question.title
      click_on 'Delete question'

      expect(page).to have_content 'Question was successfully deleted'
      expect(current_path).to eq questions_path
      expect(page).to have_no_content question.body
      expect(page).to have_no_content question.title
    end
  end
end
