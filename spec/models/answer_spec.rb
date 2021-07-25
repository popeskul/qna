require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'Associations' do
    it { should belong_to(:question) }
    it { should belong_to(:author) }
  end

  describe 'Validations' do
    it { should validate_presence_of :body }
  end
end
