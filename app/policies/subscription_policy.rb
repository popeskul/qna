class SubscriptionPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    user.id == record.user_id if user
  end
end
