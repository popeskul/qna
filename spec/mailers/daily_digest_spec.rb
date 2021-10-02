# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe '#digest' do
    let(:user) { create(:user, admin: true) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'mails attributes' do
      expect(mail.subject).to eq('Daily Digest')
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.to).to eq([user.email])
    end

    it 'mails body' do
      expect(mail.body.encoded).to match("Hello #{user.email}!")
    end
  end
end
