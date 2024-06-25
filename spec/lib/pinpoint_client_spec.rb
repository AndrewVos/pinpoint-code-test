require "rails_helper"

RSpec.describe PinpointClient do
  let(:subject) { described_class }

  before do
    allow(ENV).to receive(:fetch).with("PINPOINT_DOMAIN").and_return(
      "http://pinpoint.blah/api"
    )
    allow(ENV).to receive(:fetch).with("PINPOINT_API_KEY").and_return("apikey")
  end

  describe "#get" do
    context "with a successful response" do
      before do
        http = double(:http)

        allow(HTTP).to receive(:headers).and_return(http)

        response =
          double(
            :response,
            body: "{\"some\": \"thing\"}",
            status: double(success?: true)
          )
        allow(http).to receive(:get).and_return(response)
      end

      it "authenticates the request" do
        PinpointClient.get("/some/path")

        expect(HTTP).to have_received(:headers).with(
          { "X-API-KEY" => "apikey" }
        )
      end

      it "sends an authenticated request and returns the parsed response" do
        response = PinpointClient.get("/some/path")

        expect(response).to eq({ some: "thing" })
      end
    end

    context "with an unsuccessful response" do
      before do
        http = double(:http)

        response =
          double(
            :response,
            body: "error body",
            status: double(success?: false),
            code: 500
          )

        allow(HTTP).to receive(:headers).and_return(http)
        allow(http).to receive(:get).and_return(response)
      end

      it "raises an error" do
        expect { PinpointClient.get("/some/other/path") }.to raise_error(
          "Pinpoint request failed\nURL:http://pinpoint.blah/api/some/other/path\nCode: 500\nBody:error body"
        )
      end
    end
  end

  describe "#post" do
    context "with a successful response" do
      before do
        http = double(:http)

        allow(HTTP).to receive(:headers).and_return(http)

        response =
          double(
            :response,
            body: "{\"some\": \"thing\"}",
            status: double(success?: true)
          )
        allow(http).to receive(:post).and_return(response)
      end

      it "authenticates the request" do
        PinpointClient.post("/some/path", { some: "post" })

        expect(HTTP).to have_received(:headers).with(
          { "X-API-KEY" => "apikey" }
        )
      end

      it "sends an authenticated request and returns the parsed response" do
        response = PinpointClient.post("/some/path", { some: "post" })

        expect(response).to eq({ some: "thing" })
      end
    end

    context "with an unsuccessful response" do
      before do
        http = double(:http)

        response =
          double(
            :response,
            body: "error body",
            status: double(success?: false),
            code: 500
          )

        allow(HTTP).to receive(:headers).and_return(http)
        allow(http).to receive(:post).and_return(response)
      end

      it "raises an error" do
        expect {
          PinpointClient.post("/some/other/path", { some: "body" })
        }.to raise_error(
          "Pinpoint request failed\nURL:http://pinpoint.blah/api/some/other/path\nCode: 500\nBody:error body"
        )
      end
    end
  end
end
