# frozen_string_literal: true

# AttachmentPolicy
class AttachmentPolicy < ApplicationPolicy
  def destroy?
    user.id == record.author_id if user
  end

  def create?
    user.present?
  end
end
