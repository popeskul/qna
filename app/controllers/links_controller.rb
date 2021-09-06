# frozen_string_literal: true

# LinksController
class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  before_action :link

  def destroy
    link.destroy if current_user&.author_of?(link.linkable)
  end

  private

  def link
    @link = Link.find(params[:id])
  end
end
