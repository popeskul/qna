require 'rails_helper'

feature 'User can log out', %q{
  In order to log out from the system
  As an authenticated user
  I'd like to be able to log out
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
  end

  scenario 'Authenticated user can log out' do
    click_on 'Log out'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'
  end
end