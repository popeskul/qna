# frozen_string_literal: true

# AnswersController
class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[new destroy]
  after_action :publish_answer, only: %i[create]

  include Voted

  expose :question, -> { Question.find(params[:question_id]) if params[:question_id] }
  expose :answer, find: -> { Answer.with_attached_files.find(params[:id]) }

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

  def set_as_the_best
    answer.set_the_best_answer if current_user.author_of?(answer.question)
    @question = answer.question
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{params[:question_id]}/answers", {
        partial: ApplicationController.render(partial: 'answers/answer',
                                              locals: { answer: @answer, current_user: current_user }),
        answer: @answer,
        links: @answer.links,
        files: @answer.files
      }
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end
end
