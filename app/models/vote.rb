class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user,         presence: true
  validates :user_id,      uniqueness: { scope: %i[votable_type votable_id], message: 'You have already voted' }
  validates :value,        presence: true, inclusion: { in: [-1, 1] }
  validates :votable_type, inclusion: { in: %w[Question Answer] }
end
