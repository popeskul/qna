require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question author's
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/popeskul/234ed2442767c1b6df545a3433006cc1' }

  scenario 'User add links when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'body body body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Post an answer'

    within '.answer' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end