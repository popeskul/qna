# frozen_string_literal: true

# model Link
class Link < ApplicationRecord
  belongs_to :linkable, touch: true, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def gist?
    URI.parse(url).host.include?('gist')
  end

  def gist_id
    URI.parse(url).path.split('/').last
  end
end
