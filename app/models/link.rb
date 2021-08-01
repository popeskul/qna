class Link < ApplicationRecord
  belongs_to :linkable, touch: true, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true
end
