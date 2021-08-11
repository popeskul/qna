require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'Associations' do
    it { should belong_to(:votable) }
    it { should belong_to(:user) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:user) }

    it { should validate_inclusion_of(:votable_type).in_array(%w[Question Answer]) }
    it { should validate_inclusion_of(:value).in_array([-1, 1]) }
  end
end
