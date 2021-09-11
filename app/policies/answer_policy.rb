# frozen_string_literal: true

# AnswerPolicy
class AnswerPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def destroy?
    user == record.author
  end

  def update?
    user == record.author
  end

  def set_as_the_best?
    user == record.question.author
  end
end
