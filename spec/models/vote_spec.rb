# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'Associations' do
    it { should belong_to(:votable) }
    it { should belong_to(:user) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:user) }

    it { should validate_inclusion_of(:votable_type).in_array(%w[Question Answer]) }
    it { should validate_inclusion_of(:value).in_array([-1, 1]) }
  end

  describe '#votable_author?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:question2) { create(:question) }
    let(:vote) { create(:question_vote, user: user, votable: question) }
    let(:vote2) { create(:question_vote, user: user, votable: question2) }

    it 'author of Vote is the same as original Question' do
      expect(vote.not_votable_author).to eq true
    end

    it 'user is not author' do
      expect(vote2.not_votable_author).to eq false
    end
  end
end
