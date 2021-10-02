# frozen_string_literal: true

# AnswerPolicy
class AnswerPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def destroy?
    user.id == record.author_id if user
  end

  def update?
    user&.id == record.author_id if user
  end

  def set_as_the_best?
    user.id == record.question.author_id if user
  end
end
