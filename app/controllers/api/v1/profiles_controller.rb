# frozen_string_literal: true

# ProfilesController
module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def me
        render json: current_resource_owner
      end

      def index
        @profiles = User.where.not(id: current_resource_owner.id)
        render json: @profiles
      end
    end
  end
end
