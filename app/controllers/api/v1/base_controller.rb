# frozen_string_literal: true

# Api BaseController
module Api
  module V1
    # BaseController
    class BaseController < ApplicationController
      before_action :doorkeeper_authorize!

      def current_user
        @current_user || User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
