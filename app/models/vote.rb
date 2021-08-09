class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user,         presence: true
  validates :user_id,      uniqueness: { scope: %i[votable_type votable_id], message: 'You have already voted' }
  validates :value,        presence: true, inclusion: { in: [-1, 1] }
  validates :votable_type, inclusion: { in: %w[Question Answer] }
  validate  :not_votable_author

  def need_un_vote?(value)
    persisted? && self.value == value
  end

  def not_votable_author
    votable && self.user_id == votable.author_id
  end
end
