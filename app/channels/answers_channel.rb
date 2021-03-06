# frozen_string_literal: true

# AnswersChannel
class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "questions/#{params[:question_id]}/answers"
  end
end
