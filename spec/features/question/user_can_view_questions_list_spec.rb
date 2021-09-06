# frozen_string_literal: true

require 'rails_helper'

feature 'User is able to view questions list', %(
  Any user is able to view question list
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, author: user) }

  background { sign_in(user) }

  scenario 'User try to view existed questions list' do
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'User try to view non-existed questions list' do
    expect(page).to_not have_selector 'question-title'
  end
end
