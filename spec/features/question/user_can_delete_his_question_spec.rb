require 'rails_helper'

feature 'User can delete his question' do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }

  let(:question) { create(:question, :with_files, author: user) }

  describe 'Authenticated' do
    background { sign_in(user) }

    scenario 'user can delete his question', js: true do
      visit question_path(question)

      expect(page).to have_content question.body
      expect(page).to have_content question.title
      click_on 'Delete question'

      expect(page).to have_content 'Question was successfully deleted'
      expect(current_path).to eq questions_path
      expect(page).to have_no_content question.body
      expect(page).to have_no_content question.title
    end

    scenario 'user can delete attachments', js: true do
      visit question_path(question)

      expect(page).to have_link question.files[0].filename.to_s

      click_on 'Delete file'

      expect(page).to_not have_link question.files[0].filename.to_s
    end

    scenario "user can not delete another''s question" do
      question = create(:question, author: user1)

      visit question_path(question)

      expect(page).to have_no_content 'Delete question'
    end
  end

  describe 'Non-authenticated' do
    scenario "user can't delete question" do
      visit question_path(question)

      expect(page).to have_no_content('Delete question')
    end
  end
end
