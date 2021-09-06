# frozen_string_literal: true

require 'rails_helper'

feature 'User can view a question and its answers', '
  In order to have new knowledge, user can view
  any questions and those answers
' do
  let(:question) { create(:question_with_answers) }

  scenario 'User can view a question and its answers' do
    visit question_path(question)

    expect(page).to have_content(question.body)

    question.answers.each { |q| expect(page).to have_content(q.body) }
  end
end
