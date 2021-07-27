require 'rails_helper'

feature 'Edit an answer', %q{
  In order to fix errors
  Author can edit his answer
} do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let(:question2) { create :question, author: user }
  let(:another_answer) { create :answer }

  scenario 'Non authenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    describe 'tries to edit his answer' do
      scenario 'Author sees Edit link' do
        within '.answers' do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'edits his answer', js: true do
        click_on 'Edit'
        within '.answers' do
          fill_in 'answer[body]', with: 'edited answer'
          click_on 'Save'
          expect(page).not_to have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end

    scenario 'tries to edit others answer' do
      visit question_path(question2)
      expect(page).to_not have_link 'Edit'
    end
  end
end