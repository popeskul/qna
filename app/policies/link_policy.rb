# frozen_string_literal: true

# LinkPolicy
class LinkPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    user&.author_of?(record.linkable)
  end

  def destroy?
    user&.author_of?(record.linkable)
  end
end
