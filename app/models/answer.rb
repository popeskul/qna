class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question, touch: true

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def set_the_best_answer
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
