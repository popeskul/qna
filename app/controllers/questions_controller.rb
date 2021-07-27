class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, ->{ Question.all }
  expose :question

  def show
    @answer = question.answers.new
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

  def question_params
    params.require(:question).permit(:title, :body, :file)
  end
end
