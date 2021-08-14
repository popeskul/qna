class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: %i[create]

  include Voted

  expose :questions, -> { Question.all }
  expose :question, find: -> { Question.with_attached_files.find(params[:id]) }

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def show
    @answer = question.answers.new
    @answer.links.new

    gon.push({
               current_user: current_user,
               question_id: question.id
             })
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(question)
      question.update(question_params)
      flash.now[:notice] = 'The question was updated successfully.'
    end

    @questions = questions
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      flash[:notice] = 'Question was successfully deleted'
      redirect_to questions_path
    else
      redirect_to question
    end
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question, current_user: current_user }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url], reward_attributes: %i[title image])
  end
end
