# frozen_string_literal: true

# module Votable
module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    make_vote(user, 1)
  end

  def vote_down(user)
    make_vote(user, -1)
  end

  def un_vote(user)
    votes.destroy_all if voted_by?(user)
  end

  def voted_by?(user)
    votes.exists?(user: user)
  end

  def evaluation
    votes.sum(:value)
  end

  private

  def make_vote(user, value)
    vote = votes.find_or_initialize_by(user_id: user.id)

    return if vote.not_votable_author || vote.value == value

    vote.value = value
    vote.save
  end
end
