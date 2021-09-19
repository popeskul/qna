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
        @answer = question.answers.new(answer_params)
        @answer.author = current_resource_owner

        flash.now[:notice] = 'The answer was created successfully.' if @answer.save
      end

      def destroy
        answer.destroy
        flash.now[:notice] = 'Answer was successfully deleted'
      end

      def update
        answer.update(answer_params)
        flash.now[:notice] = 'The answer was updated successfully.'

        @answer = answer
      end

      def set_as_the_best
        answer.set_the_best_answer
        @question = answer.question
      end

      private

      def answer_params
        params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
      end
    end
  end
end
