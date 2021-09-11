# frozen_string_literal: true

# CommentPolicy
class CommentPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    user && user.id == record.user_id
  end

  def destroy?
    user && user.id == record.user_id
  end
end
