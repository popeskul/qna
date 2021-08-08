require 'rails_helper'

shared_examples_for 'votable' do
  let(:user)  { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym, author: user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#vote_up' do
    it 'user can vote up' do
      model.vote_up(user)
      expect(model.evaluation).to eq(1)
    end

    it 'user can not vote up twice' do
      model.vote_up(user)
      model.vote_up(user)

      expect(model.evaluation).to eq(1)
    end
  end

  describe '#vote_down' do
    it 'user can vote down' do
      model.vote_down(user)
      expect(model.evaluation).to eq(-1)
    end

    it 'user can not vote down twice' do
      model.vote_down(user)
      model.vote_down(user)

      expect(model.evaluation).to eq(-1)
    end
  end
end
