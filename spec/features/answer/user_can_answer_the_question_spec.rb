require 'rails_helper'

feature 'User can answer the question', %q{
  In order to answer the question, user can fill
  form and submit
} do
  given(:question) { create(:question) }
  
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    
    scenario 'Authenticated user answer the question' do
      sign_in(user)

      visit question_path(question)

      fill_in 'Body', with: 'body'
      click_on 'Post an answer'

      expect(page).to have_content 'The question was created successfully.'
    end

    scenario 'Authenticated user answer the question with errors' do
      sign_in(user)

      visit question_path(question)
      click_on 'Post an answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries answer the question' do
    visit question_path(question)
    click_on 'Post an answer'

    expect(page).to have_content "Body can't be blank"
  end
end
