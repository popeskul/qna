# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { should have_many(:rewards).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'Author_of?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, author_id: user2.id) }

    context 'question' do
      let(:users_question) { create(:question, author_id: user.id) }

      it 'user is the author of the question' do
        expect(user).to be_author_of(users_question)
      end

      it 'user is not author of the question' do
        expect(user).to_not be_author_of(question)
      end
    end

    context 'answer' do
      let(:answer) { create(:answer, author: user2, question: question) }

      it 'user is the author of the answer' do
        expect(user2).to be_author_of(answer)
      end

      it 'user is not author of the answer' do
        expect(user).to_not be_author_of(answer)
      end
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
