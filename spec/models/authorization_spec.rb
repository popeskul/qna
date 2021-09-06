# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authorization, type: :model do
  describe 'Associations' do
    it { should belong_to(:user) }
  end

  describe 'Validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
  end
end
