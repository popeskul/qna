class SubscriptionPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    user == record.user
  end
end
