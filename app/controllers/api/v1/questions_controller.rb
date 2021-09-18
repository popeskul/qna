# frozen_string_literal: true

# Api for Questions Controller
module Api
  module V1
    # QuestionsController
    class QuestionsController < Api::V1::BaseController
      expose :questions, -> { Question.all }
      expose :question, -> { Question.find(params[:id]) }

      def index
        render json: questions
      end

      def show
        render json: question, serializer: QuestionDataSerializer
      end

      def new
        @question = Question.new
        @question.links.new
        @question.build_reward
      end

      def create
        @question = current_resource_owner.questions.new(question_params)
        redirect_to @question, notice: 'Your question successfully created.' if @question.save
      end

      def update
        question.update(question_params)
        flash.now[:notice] = 'The question was updated successfully.'

        @questions = questions
      end

      def destroy
        question.destroy
      end

      private

      def question_params
        params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url],
                                                        reward_attributes: %i[title image])
      end
    end
  end
end
