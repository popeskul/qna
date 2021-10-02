require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "notification" do
    let(:user)     { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer)   { create(:answer, author: user, question: question) }
    let(:service)  { double('Services::Notification') }
    let(:mail)     { NotificationMailer.notification(user, answer) }

    before do
      allow(Services::Notification).to receive(:new).and_return(service)
    end

    it '#send_notification' do
      expect(service).to receive(:send_notification)
      NotificationJob.perform_now(answer)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("You have got a new answer to your question")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end

end
