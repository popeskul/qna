require 'rails_helper'

feature 'Edit an question', %q{
  In order to fix errors
  Author can edit his question
} do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  let!(:question) { create(:question, author_id: user.id) }
  let(:question2) { create :question }

  scenario 'Non authenticated user tries to edit question' do
    visit questions_path
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    describe 'tries to edit his questions' do
      before do
        sign_in(user)
        visit questions_path
      end

      scenario 'user sees Edit link' do
        within '.questions' do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'user edit his question', js: true do
        click_on 'Edit'

        within '.question' do
          edit_title = 'edited question title'
          edit_body = 'edited question body'
          fill_in 'Title', with: edit_title
          fill_in 'Body', with: edit_body
          click_on 'Save'

          expect(page).to have_content edit_body
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'user edit his question with the new files', js: true do
        click_on 'Edit'

        within '.question' do
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end

    describe 'tries to edit others question' do
      before do
        sign_in(user2)
        visit questions_path
      end

      scenario 'can not delete question' do
        visit questions_path

        expect(page).to have_content question.body
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
