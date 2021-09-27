# frozen_string_literal: true

# Model for Question
class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files
  has_one :reward, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  after_create :calculate_reputation

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
