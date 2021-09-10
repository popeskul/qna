# frozen_string_literal: true

module ActiveStorage
  # AttachmentsController
  class AttachmentsController < ApplicationController
    before_action :authenticate_user!

    expose :attachment, -> { ActiveStorage::Attachment.find(params[:id]) }

    def destroy
      attachment.purge if authorize! :destroy, attachment
    end
  end
end
