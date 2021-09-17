# frozen_string_literal: true

# ProfilesController
module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        @questions = Question.all
        render json: { questions: @questions.to_json(include: :answers) }
      end
    end
  end
end
