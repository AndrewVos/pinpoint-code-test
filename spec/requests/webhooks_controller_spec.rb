require "rails_helper"

RSpec.describe "WebhooksControllers", type: :request do
  describe "POST /webhooks" do
    context "with a supported event" do
      it "starts a job to process the event" do
        allow(WebhooksApplicationHiredJob).to receive(:perform_later)

        post "/webhooks",
             params: {
               event: "application_hired",
               data: {
                 application: {
                   id: 1111
                 }
               }
             },
             as: :json

        expect(response).to have_http_status(:accepted)

        expect(WebhooksApplicationHiredJob).to have_received(
          :perform_later
        ).with(1111)
      end
    end

    context "with an unsupported event" do
      it "returns an error" do
        post "/webhooks", params: { event: "application_rejected" }, as: :json

        expect(response).to be_bad_request
      end
    end
  end
end
