# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question author's
  I'd like to be able to add links
" do
  given(:user) { create(:user) }

  given!(:question) { create(:question, author: user) }

  given(:url) { 'https://www.google.com/' }
  given(:url2) { 'https://www.youtube.com/' }

  given(:invalid_url) { 'invalid_url' }

  describe 'Authenticated' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User adds many links to question', js: true do
      link_name = 'Link name'
      link_name2 = 'Link name 2'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

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

    scenario 'User tries to add an invalid url address to question', js: true do
      fill_in 'Link name', with: 'Link name'
      fill_in 'Url', with: invalid_url

      click_on 'Ask'

      expect(page).to have_content 'Links url must be a valid URL'
    end

    scenario 'The author of the question can add a new links', js: true do
      link_name = 'Link name'

      visit questions_path

      within '.questions' do
        click_on 'Edit'

        click_on 'Add link'

        within '.question' do
          fill_in 'Link name', with: link_name
          fill_in 'Url', with: url2
        end

        click_on 'Save'
      end

      visit question_path(question)

      expect(page).to have_link link_name, href: url2
    end

    scenario 'The author of the question can edit a link', js: true do
      link_name = 'Link name'
      link_name2 = 'Link name 2'

      visit questions_path

      click_on 'Edit'
      click_on 'Add link'

      within '.questions' do
        fill_in 'Link name', with: link_name
        fill_in 'Url', with: url

        click_on 'Save'
      end

      visit questions_path

      within '.questions' do
        click_on 'Edit'

        within '.question' do
          fill_in 'Link name', with: link_name2
          fill_in 'Url', with: url2
        end

        click_on 'Save'
      end

      visit question_path(question)

      expect(page).to have_link link_name2, href: url2
    end
  end
end
