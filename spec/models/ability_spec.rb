# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    let(:question) { create(:question, author: user) }
    let(:another_question) { create(:question, author: another_user) }

    context 'All resources' do
      it { should_not be_able_to :manage, :all }
      it { should be_able_to :read, :all }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :destroy, Answer }

      it { should be_able_to :update, create(:answer, author: user, question: question) }
      it { should_not be_able_to :update, create(:answer, author: another_user, question: another_question) }

      it { should be_able_to :set_as_the_best, create(:answer, author: user, question: question) }
      it { should_not be_able_to :set_as_the_best, create(:answer, author: another_user, question: another_question) }

      it { should_not be_able_to %i[vote_up vote_down un_vote], create(:answer, author: user, question: question) }
      it do
        should be_able_to %i[vote_up vote_down un_vote],
                          create(:answer, author: another_user, question: another_question)
      end

      it { should be_able_to :comment, Answer }
    end

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :destroy, Question }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, another_question }

      it { should_not be_able_to %i[vote_up vote_down un_vote], question }
      it { should be_able_to %i[vote_up vote_down un_vote], another_question }

      it { should be_able_to [:comment], Question }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context 'Link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: another_question) }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end
  end
end
