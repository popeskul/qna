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
      fill_in 'Title', with: 'title title'
      fill_in 'Body', with: 'text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'title title'
      expect(page).to have_content 'text text'
    end

    scenario 'Authenticated asks a question with attached files' do
      fill_in 'Title', with: 'title title'
      fill_in 'Body', with: 'text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Authenticated user asks a question with errors' do
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