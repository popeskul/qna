require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'Associations' do
    it { should belong_to(:question) }
    it { should belong_to(:author) }
  end

  describe 'Validations' do
    it { should validate_presence_of :body }
  end

  describe '#set_the_best_answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user, best: false) }
    let!(:answer2) { create(:answer, question: question, author: user, best: false) }

    it 'sets the best answer' do
      best_answer = question.answers[1]
      best_answer.set_the_best_answer
      best_answer.reload
      expect(best_answer).to be_best
    end

    it 'resets the best answer' do
      best_answer = question.answers[0]
      best_answer.set_the_best_answer
      new_best_answer = question.answers[1]
      new_best_answer.set_the_best_answer
      new_best_answer.reload
      expect(new_best_answer).to be_best
    end
  end

  describe 'answers sorted by the best attribute' do
    let!(:question) { create(:question_with_answers) }
    it 'sorts answers' do
      best_answer = question.answers[1]
      best_answer.set_the_best_answer
      question.reload
      expect(question.answers[0]).to eq best_answer
    end
  end
end
