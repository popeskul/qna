# frozen_string_literal: true

# SearchController
class SearchController < ApplicationController
  def index
    @result = Services::Search.search_by(params[:query], params[:type])
  end
end
