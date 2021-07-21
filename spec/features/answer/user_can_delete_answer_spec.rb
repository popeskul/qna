require 'rails_helper'

feature 'User can delete his answer' do
  let(:user) { create(:user)}
  let(:user1) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:question1) { create(:question, author: user1) }

  scenario 'Authenticated user can delete his answer' do
    sign_in(user)

    answer = create(:answer, question: question)

    visit answer_path(answer)

    click_on 'Delete answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Answer was successfully deleted'
    expect(page).to have_no_content answer.body
  end

  scenario "Authenticated user can not delete another''s answer" do
    sign_in(user1)

    answer = create(:answer, question: question1)

    visit question_path(question1)

    expect(page).to have_no_link('Delete', href: answer_path(answer))
  end

  scenario "Non-authenticated user can not delete another''s answer" do
    answer = create(:answer, question: question1)

    expect(page).to have_no_link('Delete', href: answer_path(answer))
  end
end
