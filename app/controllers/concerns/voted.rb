# frozen_string_literal: true

# Voted
module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable,     only: %i[vote_up vote_down un_vote]
    before_action :validate_votable, only: %i[vote_up vote_down un_vote]
  end

  def vote_up
    success_response if @votable.vote_up(current_user)
  end

  def vote_down
    success_response if @votable.vote_down(current_user)
  end

  def un_vote
    success_response if @votable.un_vote(current_user)
  end

  private

  def validate_votable
    error_response('Author can not vote') if current_user.author_of?(@votable)
  end

  def success_response
    render json: {
      id: @votable.id,
      name: @votable.class.name.underscore,
      evaluation: @votable.evaluation
    }
  end

  def error_response(message)
    render json: { message: message }, status: :forbidden
  end

  def find_votable
    @votable = klass_model.find(params[:id])
  end

  def klass_model
    controller_name.classify.constantize
  end
end
