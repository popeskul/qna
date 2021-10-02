# frozen_string_literal: true

# QuestionsController
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: %i[create]

  include Voted

  expose :questions, -> { Question.all }
  expose :question, find: -> { Question.with_attached_files.find(params[:id]) }

  def new
    authorize Question

    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def show
    @answer = question.answers.new
    @answer.links.new

    gon.push({ current_user: current_user, question_id: question.id })
  end

  def create
    authorize question

    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: t('.success')
    else
      render :new
    end
  end

  def update
    authorize question

    question.update(question_params)
    flash.now[:notice] = t('.success')

    @questions = questions
  end

  def destroy
    authorize question

    question.destroy
    redirect_to questions_path, notice: t('.success')
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions', {
        partial: ApplicationController.render(
          partial: 'questions/question',
          locals: { question: @question, current_user: current_user }
        ),
        question: @question
      }
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url],
                                                    reward_attributes: %i[title image])
  end
end
