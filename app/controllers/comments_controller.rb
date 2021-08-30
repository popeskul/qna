class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action  :publish_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))

    flash.now[:notice] = 'The comment was created successfully.' if @comment.save
  end

  private

  def set_commentable
    @commentable = Answer.find_by(id: params[:answer_id]) || Question.find_by(id: params[:question_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comments-#{channel.id}", {
        partial: ApplicationController.render(partial: 'comments/comment', locals: { comment: @comment }),
        comment: @comment
      }
    )
  end

  def channel
    @comment.commentable_type.to_sym == :Answer ? @comment.commentable.question : @comment.commentable
  end
end
