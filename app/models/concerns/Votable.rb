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

  def evaluation
    votes.sum(:value)
  end

  def exists_user?(user)
    votes.exists?(user: user)
  end

  private

  def make_vote(user, value)
    vote = votes.find_or_initialize_by(user_id: user.id)

    return if vote.not_votable_author

    if vote.need_un_vote?(value)
      vote.destroy
    else
      vote.value = value
      vote.save
    end
  end
end
