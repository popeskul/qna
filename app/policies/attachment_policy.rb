# frozen_string_literal: true

# AttachmentPolicy
class AttachmentPolicy < ApplicationPolicy
  def destroy?
    user == record.author
  end

  def create?
    user.present?
  end
end
