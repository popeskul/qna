module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable,     only: %i[vote_up vote_down]
    before_action :validate_votable, only: %i[vote_up vote_down]
    after_action  :success_response, only: %i[vote_up vote_down un_vote]
  end

  def vote_up
    @votable.vote_up(current_user)
  end

  def vote_down
    @votable.vote_down(current_user)
  end

  def un_vote
    @votable.un_vote(current_user)
  end

  private

  def validate_votable
    render error_response('Author can not vote')            if current_user.author_of?(@votable)
    render error_response('You have already voted earlier') if @votable.exists_user?(@votable)
  end

  def success_response
    { json: {
      # name: @votable.class.name.underscore,
      # id: @votable.id,
      # rating: @votable.rating
    } }
  end

  def error_response(message)
    { json: { message: message }, status: :forbidden }
  end

  def find_votable
    @votable = klass_model.find(params[:id])
  end

  def klass_model
    controller_name.classify.constantize
  end
end
