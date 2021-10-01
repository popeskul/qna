require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end
end
