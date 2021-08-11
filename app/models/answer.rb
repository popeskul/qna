class Answer < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question, touch: true

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  default_scope { order(best: :desc) }

  def set_the_best_answer
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: author)
    end
  end
end
