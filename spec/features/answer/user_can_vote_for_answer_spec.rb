require 'rails_helper'

feature 'Vote for answer', %(
  In order to show votes about the answer
  As an authorized user
  I'd like to be able to vote for answer
) do
  let(:user)       { create(:user) }
  let(:user2)      { create(:user) }

  let(:question)  { create(:question, author: user) }
  let(:question2) { create(:question, author: user2) }

  let!(:answer) { create(:answer, question: question, author: user) }
  let!(:answer2) { create(:answer, question: question2, author: user2) }

  scenario 'Unauthorized user can not vote for answer', :js do
    visit question_path(question)

    within '.answer-votes' do
      find(:css, '.vote-up').click

      expect(page).to have_content '0'
    end

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'Authorized user' do
    before { sign_in(user) }

    describe 'as author this answer' do
      scenario 'user can not vote', :js do
        visit question_path(question)

        within '.answer-votes' do
          find(:css, '.vote-up').click

          expect(page).to have_content '0'
        end

        expect(page).to have_content 'Author can not vote'
      end
    end

    describe 'as not author this answer' do
      scenario 'user can vote up', :js do
        visit question_path(question2)

        within '.answer-votes' do
          find(:css, '.vote-up').click

          expect(page).to have_content '1'
        end
      end

      scenario 'user can vote down', :js do
        visit question_path(question2)

        within '.answer-votes' do
          find(:css, '.vote-down').click

          expect(page).to have_content '-1'
        end
      end

      scenario 'user can change vote', :js do
        answer2.votes.create(user: user2, value: 1)
        visit question_path(question2)

        within '.answer-votes' do
          expect(page).to have_content '1'

          find(:css, '.vote-down').click

          expect(page).to have_content '0'
        end
      end

      scenario 'user can un vote', :js do
        answer2.votes.create(user: user, value: 1)
        visit question_path(question2)

        within '.answer-votes' do
          expect(page).to have_content '1'

          find(:css, '.vote-up').click

          expect(page).to have_content '0'
        end
      end
    end
  end
end
