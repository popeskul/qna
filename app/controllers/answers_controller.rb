class AnswersController < ApplicationController
  expose :question, ->{ Question.find(params[:question_id]) }
  expose :answer

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      flash[:notice] = 'The answer was created successfully.'
      redirect_to question
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      flash[:notice] = 'Answer was successfully deleted'
      redirect_to question_path(@answer.question)
    else
      flash[:error] = 'Cannot delete the answer'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
