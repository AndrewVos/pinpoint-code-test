require "rails_helper"

RSpec.describe HibobClient, type: :job do
  let(:subject) { described_class }

  describe "#post" do
    before do
      allow(ENV).to receive(:fetch).with("HIBOB_SERVICE_USER_ID").and_return(
        "user"
      )
      allow(ENV).to receive(:fetch).with(
        "HIBOB_SERVICE_USER_PASSWORD"
      ).and_return("password")

      allow(HTTP).to receive(:basic_auth).and_return(HTTP)
      allow(HTTP).to receive(:headers).and_return(HTTP)
      allow(HTTP).to receive(:post).and_return(http_response)
    end

    let(:http_status) do
      http_status = double
      allow(http_status).to receive(:success?).and_return(true)
      http_status
    end

    let(:http_response) do
      http_response = double
      allow(http_response).to receive(:status).and_return(http_status)
      allow(http_response).to receive(:parse).and_return("parsed response")
      http_response
    end

    it "authenticates requests" do
      subject.post("some url", { sample: "body" })

      expect(HTTP).to have_received(:basic_auth).with(
        { user: "user", pass: "password" }
      )
    end

    it "sends the request" do
      subject.post("some url", { sample: "body" })

      expect(HTTP).to have_received(:post).with(
        "some url",
        json: {
          sample: "body"
        }
      )
    end

    it "returns the parsed response" do
      expect(subject.post("some url", { sample: "body" })).to eq(
        "parsed response"
      )
    end

    context "with an unsuccessful response" do
      before do
        allow(http_status).to receive(:success?).and_return(false)
        allow(http_response).to receive(:body).and_return("error body")
        allow(http_response).to receive(:code).and_return(500)
      end

      it "raises an error" do
        expect { subject.post("some url", { sample: "body" }) }.to raise_error(
          "Hibob request failed\nURL:some url\nCode: 500\nBody:error body"
        )
      end
    end
  end
end
