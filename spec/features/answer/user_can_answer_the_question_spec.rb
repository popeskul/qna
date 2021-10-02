# frozen_string_literal: true

require 'rails_helper'

feature 'User can answer the question', '
  In order to answer the question, user can fill
  form and submit
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer_text) { Faker::Lorem.unique.sentence }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Authenticated user answer the question', js: true do
      fill_in 'Answer', with: answer_text

      click_on 'Post an answer'

      expect(page).to have_content 'The answer was created successfully.'
      expect(page).to have_content answer_text
    end

    scenario 'Authenticated user answer the question with attached files', js: true do
      fill_in 'Answer', with: answer_text
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Post an answer'

      expect(page).to have_content 'The answer was created successfully.'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_content answer_text
    end

    scenario 'Authenticated user answer the question with errors', js: true do
      click_on 'Post an answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Unauthenticated user tries answer the question with correct body' do
      visit question_path(question)

      expect(page).to_not have_css '.new-answer'
    end
  end

  context 'multiple session' do
    scenario 'answer appears on another user page', js: true do
      using_session('guest') do
        visit question_path(question)
      end

      using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      using_session('user') do
        fill_in 'Answer', with: answer_text
        click_on 'Post an answer'

        expect(page).to have_content 'The answer was created successfully.'
        expect(page).to have_content answer_text
      end

      using_session('guest') do
        expect(page).to have_content answer_text
      end
    end
  end
end
