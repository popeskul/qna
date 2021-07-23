require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a communicaty
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'Authenticated user asks a question' do
      visit questions_path

      click_on 'Ask question'

      fill_in 'Title', with: 'title title'
      fill_in 'Body', with: 'text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'title title'
      expect(page).to have_content 'text text'
    end

    scenario 'Authenticated user asks a question with errors' do
      visit questions_path

      click_on 'Ask question'
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to asks a question' do
    visit questions_path

    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end