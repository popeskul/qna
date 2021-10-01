# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionPolicy, type: :policy do
  subject { described_class.new(user, subscription) }

  context 'being a visitor' do
    let(:user) { nil }
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription) }

    it { is_expected.to forbid_actions(%i[create destroy edit update new]) }
  end

  context 'being an authorized but not author of resource' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription, question: question) }

    it { is_expected.to forbid_actions(%i[destroy edit update]) }
    it { is_expected.to permit_actions(%i[create new]) }
  end

  context 'being an author of resource' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription, user: user, question: question) }

    it { is_expected.to forbid_actions(%i[edit update]) }
    it { is_expected.to permit_actions(%i[create destroy]) }
  end
end
