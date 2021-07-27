require 'rails_helper'

feature 'User can delete his question' do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }

  let(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'Authenticated user can delete his question', js: true do
      visit question_path(question)

      expect(page).to have_content question.body
      expect(page).to have_content question.title
      click_on 'Delete question'

      expect(page).to have_content 'Question was successfully deleted'
      expect(current_path).to eq questions_path
      expect(page).to have_no_content question.body
      expect(page).to have_no_content question.title
    end

    scenario "Authenticated user can not delete another''s question" do
      question = create(:question, author: user1)

      visit question_path(question)

      expect(page).to have_no_content 'Delete question'
    end
  end

  describe 'Non-authenticated user' do
    scenario "Non-authenticated user can't delete question" do
      visit question_path(question)

      expect(page).to have_no_content('Delete question')
    end
  end
end
