# frozen_string_literal: true

# QuestionPolicy
class QuestionPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.id == record.author_id if user
  end

  def destroy?
    user.id == record.author_id if user
  end

  def comment?
    user.present?
  end

  def vote?
    user.id != record.author_id if user
  end
end
