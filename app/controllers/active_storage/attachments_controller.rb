# frozen_string_literal: true

module ActiveStorage
  # AttachmentsController
  class AttachmentsController < ApplicationController
    before_action :authenticate_user!

    expose :attachment, -> { Attachment.find(params[:id]) }

    def destroy
      authorize load_record
      attachment.purge
    end

    private

    def load_record
      attachment.record_type.classify.constantize.find(attachment.record_id)
    end
  end
end
