class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create

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
end
