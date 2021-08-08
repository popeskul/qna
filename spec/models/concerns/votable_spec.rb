require 'rails_helper'

shared_examples_for 'votable' do
  let(:user)  { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym, author: user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#vote_up' do
    before { model.vote_up(user) }

    it 'user can vote up' do
      expect(model.evaluation).to eq(1)
    end

    it 'user can not vote up twice' do
      model.vote_up(user)
      expect(model.evaluation).to eq(1)
    end
  end

  describe '#vote_down' do
    before { model.vote_down(user) }

    it 'user can vote down' do
      expect(model.evaluation).to eq(-1)
    end

    it 'user can not vote down twice' do
      model.vote_down(user)
      expect(model.evaluation).to eq(-1)
    end
  end

  describe '#un_vote' do
    before { model.vote_up(user) }

    it 'user can un vote' do
      model.un_vote(user)
      expect(model.votes).to eq([])
    end
  end
end
