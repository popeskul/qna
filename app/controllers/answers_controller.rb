class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[new destroy]

  expose :question, ->{ Question.find(params[:question_id]) if params[:question_id] }
  expose :answer

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user

    flash.now[:notice] = 'The answer was created successfully.' if @answer.save
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash.now[:notice] = 'Answer was successfully deleted'
    else
      flash.now[:error] = 'Cannot delete the answer'
    end
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
