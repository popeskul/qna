# frozen_string_literal: true

# class for permission manipulation
class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_ability : user_ability
    else
      quest_ability
    end
  end

  private

  def quest_ability
    can :read, :all
  end

  def admin_ability
    can :manage, :all
  end

  def user_ability
    quest_ability

    can %i[create comment], [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer], { author_id: user.id }

    can %i[set_as_the_best], Answer, question: { author_id: user.id }

    can %i[destroy], Link, linkable: { author_id: user.id }

    can %i[destroy], ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end

    can %i[vote_up vote_down un_vote], [Question, Answer] do |vote|
      !user.author_of?(vote)
    end
  end
end
