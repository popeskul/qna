require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question author's
  I'd like to be able to add links
" do
  given(:user) { create(:user) }

  given(:url) { 'https://www.google.com/' }
  given(:url2) { 'https://www.youtube.com/' }

  describe 'Authenticated' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'User adds many links to question', js: true do
      link_name = 'Link name'
      link_name2 = 'Link name 2'

      fill_in 'Link name', with: link_name
      fill_in 'Url', with: url

      click_on 'Add link'

      within '.nested-fields' do
        fill_in 'Link name', with: link_name2
        fill_in 'Url', with: url2
      end

      click_on 'Ask'

      expect(page).to have_link link_name, href: url
      expect(page).to have_link link_name2, href: url2
    end
  end
end
