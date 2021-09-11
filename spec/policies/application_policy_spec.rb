# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy, type: :policy do
  subject { described_class.new(user, nil) }

  context 'being a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_actions(%i[index show create new update edit destroy]) }
  end
end
