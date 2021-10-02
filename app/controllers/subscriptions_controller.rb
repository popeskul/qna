class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  expose :question, find: -> { Question.find(params[:question_id]) if params[:question_id] }
  expose :subscription, find: -> { current_user.subscriptions.find_by(question_id: params[:id]) if params[:id] }

  def create
    authorize Subscription
    @subscription = question.subscriptions.create(user: current_user)
  end

  def destroy
    authorize subscription, :destroy?
    subscription.destroy
  end
end
