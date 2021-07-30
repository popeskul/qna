require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
  end

  describe 'Associations' do
    it { should belong_to(:question) }
  end
end
