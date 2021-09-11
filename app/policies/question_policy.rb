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
    user == record.author
  end

  def destroy?
    user == record.author
  end

  def comment?
    user.present?
  end

  def vote?
    user && user != record.author
  end
end
