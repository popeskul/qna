# frozen_string_literal: true

# ProfilesController
module Api
  module V1
    # ProfilesController  for v1
    class ProfilesController < Api::V1::BaseController
      expose :profiles, -> { User.where.not(id: current_user.id) }

      def me
        render json: current_user
      end

      def index
        render json: profiles
      end
    end
  end
end
