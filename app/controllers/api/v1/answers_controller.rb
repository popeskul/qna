# frozen_string_literal: true

# Api v1 for Answer Controller
module Api
  module V1
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
    end
  end
end
