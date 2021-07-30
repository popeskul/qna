class Link < ApplicationRecord
  belongs_to :question, touch: true

  validates :name, :url, presence: true
end
