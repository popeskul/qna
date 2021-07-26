require 'rails_helper'

feature 'Author can choose the best answer' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }

  given!(:question) { create(:question, author: user) }

  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Non authenticated user' do
    scenario 'cant choose the best answer for the question' do
      visit question_path(question)
      expect(page).not_to have_link 'Mark as the best'
    end
  end

  describe 'Authenticated user' do
    describe 'if he is not the author of the question' do
      scenario 'can not choose the best answer' do
        sign_in(user2)
        visit question_path(question)
        expect(page).not_to have_link 'Mark as the best'
      end
    end

    describe 'if he is the author of the question' do
      scenario 'can choose the best answer', js: true do
        sign_in(user)
        visit question_path(question)

        best_answer = question.answers[0]

        within("#answer-#{best_answer.id}") do
          click_on 'Mark as the best'
          expect(page).to have_content 'The best answer'
        end
      end

      scenario 'can chose another answer as the best one', js: true do
        sign_in(user)
        visit question_path(question)
        another_answer = create(:answer, body: 'answer2', question: question, author: user)

        within("#answer-#{answer.id}") do
          click_on 'Mark as the best'
        end

        # Answer is the best answer?
        expect(page).to have_css "#answer-#{answer.id}", text: 'The best answer'

        within("#answer-#{another_answer.id}") do
          click_on 'Mark as the best'
        end
        # Another answer is the best one?
        expect(page).not_to have_css "#answer-#{answer.id}", text: 'The best answer'
        expect(page).to have_css "#answer-#{another_answer.id}", text: 'The best answer'
      end

      scenario 'the best answer should be the first in the list', js: true do
        create(:answer, question: question, author: user)

        sign_in(user)
        visit question_path(question)

        best_answer = question.answers[1]

        within("#answer-#{best_answer.id}") do
          click_on 'Mark as the best'
        end

        expect(page).to have_content 'The best answer'
        expect(first('.answers .answer').text).to have_content 'The best answer'
      end
    end
  end
end
