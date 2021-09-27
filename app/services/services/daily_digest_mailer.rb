# frozen_string_literal: true

# DailyDigestMailer service
module Services
  # implement DailyDigestMailer
  class DailyDigestMailer
    def send_digest
      User.find_each(batch_size: 500) do |user|
        DailyDigestMailer.digest(user).deliver_later
      end
    end
  end
end
