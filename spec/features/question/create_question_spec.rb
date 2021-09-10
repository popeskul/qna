# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get question
  As an authenticated user
  I'd like to be able to ask the question
" do
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

  context 'multiple session' do
    scenario 'question appears on another user page', js: true do
      using_session('guest') do
        visit questions_path
      end

      using_session('user') do
        sign_in(user)
        visit questions_path
      end

      using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'title title'
        fill_in 'Body', with: 'text text'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'title title'
        expect(page).to have_content 'text text'
      end

      using_session('guest') do
        expect(page).to have_content 'title title'
      end
    end
  end

  scenario 'Unauthenticated user tries to asks a question' do
    visit questions_path

    expect(page).to_not have_content 'Ask question'
  end
end
