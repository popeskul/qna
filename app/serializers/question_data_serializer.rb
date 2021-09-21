# frozen_string_literal: true

# Serializer for Data Serializer
class QuestionDataSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at
  has_many :links
  has_many :comments
  has_many :files

  def comments
    object.comments
  end

  def links
    object.links
  end

  def files
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end
