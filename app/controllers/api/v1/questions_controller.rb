# frozen_string_literal: true

# Api for Questions Controller
module Api
  module V1
    # QuestionsController
    class QuestionsController < Api::V1::BaseController
      expose :questions, -> { Question.all }
      expose :question, find: -> { Question.with_attached_files.find(params[:id]) }

      def index
        render json: questions
      end

      def show
        render json: question, serializer: QuestionDataSerializer
      end

      def create
        authorize Question

        @question = current_user.questions.new(question_params)
        redirect_to @question if @question.save
      end

      def update
        authorize question

        question.update(question_params)
        @questions = questions
      end

      def destroy
        authorize question

        question.destroy
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
