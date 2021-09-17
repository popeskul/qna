# frozen_string_literal: true

# Api BaseController
module Api
  module V1
    # BaseController
    class BaseController < ApplicationController
      before_action :doorkeeper_authorize!, unless: :user_signed_in?

      private

      def current_resource_owner
        if doorkeeper_token
          @current_resource_owner || User.find(doorkeeper_token.resource_owner_id)
        else
          warden.authenticate(scope: :user)
        end
      end
    end
  end
end
