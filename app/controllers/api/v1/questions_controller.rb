# frozen_string_literal: true

# ProfilesController
module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        render json: question, serializer: QuestionDataSerializer
      end

      private

      def question
        @question = Question.find(params[:id])
      end
    end
  end
end
