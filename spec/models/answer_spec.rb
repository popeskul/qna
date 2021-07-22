require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'Author_of?' do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let(:question) { create(:question) }

    context 'question' do
      let(:users_question) { create(:question, user_id: user.id) }

      it 'user is the author of the question' do
        expect(user).to be_author_of(users_question)
      end

      it 'user is not author of the question' do
        expect(user).to_not be_author_of(question)
      end
    end

    context 'answer' do
      let(:answer) { create(:answer, author: user2, question: question) }
      let(:users_answer) { create(:answer, user_id: user.id, question: question) }

      it 'user is the author of the answer' do
        expect(user).to be_author_of(users_answer)
      end

      it 'user is not author of the answer' do
        expect(user).to_not be_author_of(answer)
      end
    end
  end
end
