require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a communicaty
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { User.create!(email: 'user@mail.com', password: '123123') }

  scenario 'Authenticated user asks a question' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    
    visit questions_path

    click_on 'Ask question'

    fill_in 'Title', with: 'title title'
    fill_in 'Body', with: 'text text'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'title title'
    expect(page).to have_content 'text text'
  end

  scenario 'Unauthenticated user tries to asks a question' do
    visit questions_path

    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end