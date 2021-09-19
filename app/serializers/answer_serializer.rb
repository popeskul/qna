# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :question_id, :body, :best, :created_at, :updated_at
end
