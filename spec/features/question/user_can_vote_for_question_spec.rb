require 'rails_helper'

feature 'Vote for question', %(
  In order to show votes about the question
  As an authorized user
  I'd like to be able to vote for question
) do
  given(:user)       { create(:user) }
  given(:user2)      { create(:user) }

  given(:question)  { create(:question, author: user) }
  given(:question2) { create(:question, author: user2) }

  scenario 'Unauthorized user can not vote for question', :js do
    visit question_path(question)

    within '.votes' do
      find(:css, '.vote-up').click

      expect(page).to have_content '0'
    end

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'Authorized user' do
    before { sign_in(user) }

    describe 'as author this question' do
      scenario 'user can not vote', :js do
        question.update(author_id: user.id)
        visit question_path(question)

        within '.votes' do
          find(:css, '.vote-up').click

          expect(page).to have_content '0'
        end
        expect(page).to have_content 'Author can not vote'
      end
    end

    describe 'as not author this question' do
      scenario 'user can vote up', :js do
        visit question_path(question2)

        within '.votes' do
          find(:css, '.vote-up').click

          expect(page).to have_content '1'
        end
      end

      scenario 'user can vote down', :js do
        visit question_path(question2)

        within '.votes' do
          find(:css, '.vote-down').click

          expect(page).to have_content '-1'
        end
      end

      scenario 'user can change vote', :js do
        question2.votes.create(user: user2, value: 1)
        visit question_path(question2)

        within '.votes' do
          expect(page).to have_content '1'

          find(:css, '.vote-down').click

          expect(page).to have_content '0'
        end
      end

      scenario 'user can un vote', :js do
        question2.votes.create(user: user, value: 1)
        visit question_path(question2)

        within '.votes' do
          expect(page).to have_content '1'

          find(:css, '.vote-up').click

          expect(page).to have_content '0'
        end
      end
    end
  end
end
