class AnswersController < ApplicationController
  expose :question, ->{ Question.find(params[:question_id]) }

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      flash[:notice] = 'The question was created successfully.'
      redirect_to question
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
