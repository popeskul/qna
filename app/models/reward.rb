class Reward < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :title, presence: true

  has_one_attached :image
end
