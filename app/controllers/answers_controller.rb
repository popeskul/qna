class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[new]

  expose :question, ->{ Question.find(params[:question_id]) if params[:question_id] }
  expose :answer

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user

    flash.now[:notice] = 'The answer was created successfully.' if @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted'
    else
      flash[:error] = 'Cannot delete the answer'
    end

    redirect_to @answer.question
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
      flash.now[:notice] = 'The answer was updated successfully.'
    end

    @answer = answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
