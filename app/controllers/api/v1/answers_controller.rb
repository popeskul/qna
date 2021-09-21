# frozen_string_literal: true

# Api v1 for Answer Controller
module Api
  module V1
    # AnswersController for v1
    class AnswersController < Api::V1::BaseController
      expose :question, -> { Question.find(params[:question_id]) if params[:question_id] }
      expose :answer, find: -> { Answer.with_attached_files.find(params[:id]) }

      def index
        @answers = question.answers
        render json: @answers
      end

      def show
        render json: answer, serializer: AnswerDataSerializer
      end

      def create
        authorize question.answers

        @answer = question.answers.new(answer_params)
        @answer.author = current_user
        @answer.save
      end

      def destroy
        authorize answer

        answer.destroy
      end

      def update
        authorize answer

        answer.update(answer_params)

        @answer = answer
      end

      def set_as_the_best
        authorize answer

        answer.set_the_best_answer
        @question = answer.question
      end

      private

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
