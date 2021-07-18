require 'rails_helper'

feature 'User can sign up', %q{
  In order to user the service
  User can sign up
} do
  scenario 'User sign up' do
    user_password = '123123'

    visit new_user_registration_path
    fill_in 'user_email', with: 'user@test.com'
    fill_in 'user_password', with: user_password
    fill_in 'user_password_confirmation', with: user_password
    click_on 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
