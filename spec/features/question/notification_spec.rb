require 'rails_helper'

feature 'User can subscribe for the question', "
  In order to get subscription
  As an authenticated user
  I'd like to be able to subscribe for the question
" do
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Authenticated user', js: true do
    describe "try Unsubscribe" do
      before do
        sign_in(author)
        visit question_path(question)
      end

      it 'can unsubscribe' do
        within('.subscription') do
          expect(page).to_not have_content 'Subscribe'
          expect(page).to have_content 'Unsubscribe'

          click_on 'Unsubscribe'

          expect(page).to have_content 'Subscribe'
          expect(page).to_not have_content 'Unsubscribe'
        end
      end
    end

    describe "try Unsubscribe" do
      before do
        sign_in(create(:user))
        visit question_path(question)
      end

      it "can subscribe" do
        within('.subscription') do
          expect(page).to_not have_content 'Unsubscribe'
          expect(page).to have_content 'Subscribe'

          click_link 'Subscribe'

          expect(page).to have_content 'Unsubscribe'
          expect(page).to_not have_content 'Subscribe'
        end
      end
    end
  end

  describe "Not authenticated user tries subscribe", js: true do
    background { visit question_path(question) }

    scenario "User can't subscribe" do
      expect(page).to_not have_content 'Subscribe'
    end

    scenario "User can't unsubscribe" do
      expect(page).to_not have_content 'Unsubscribe'
    end
  end
end
