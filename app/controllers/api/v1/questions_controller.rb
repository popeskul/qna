# frozen_string_literal: true

# ProfilesController
module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      expose :questions, -> { Question.all }
      expose :question, -> { Question.find(params[:id]) }

      def index
        render json: questions
      end

      def show
        render json: question, serializer: QuestionDataSerializer
      end
    end
  end
end
