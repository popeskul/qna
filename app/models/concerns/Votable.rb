module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    votes.create!(user: user, value: 1) unless exists_user?(user)
  end

  def vote_down(user)
    votes.create!(user: user, value: -1) unless exists_user?(user)
  end

  def un_vote(user)
    votes.destroy_all if exists_user?(user)
  end

  def exists_user?(user)
    votes.exists?(user: user)
  end

  def evaluation
    votes.sum(:value)
  end
end
