# frozen_string_literal: true

# RewardsController
class RewardsController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    @rewards = current_user.rewards
  end
end
