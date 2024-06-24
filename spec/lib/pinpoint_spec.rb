require "rails_helper"

RSpec.describe Pinpoint, type: :job do
  let(:subject) { described_class }

  before do
    allow(ENV).to receive(:fetch).with("PINPOINT_DOMAIN").and_return(
      "http://pinpoint.blah/api"
    )
    allow(ENV).to receive(:fetch).with("PINPOINT_API_KEY").and_return("apikey")
  end

  describe "#get_application" do
    it "returns the found application" do
      allow(PinpointClient).to receive(:get).with(
        "/api/v1/applications/111?extra_fields[applications]=attachments"
      ).and_return({ application: "response" })

      result = subject.get_application(111)

      expect(result).to eq({ application: "response" })
    end
  end

  describe "#create_comment_on_application" do
    it "creates a comment on an application" do
      allow(PinpointClient).to receive(:post).with(
        "/api/v1/comments",
        {
          data: {
            type: "comments",
            attributes: {
              body_text: "comment"
            },
            relationships: {
              commentable: {
                data: {
                  type: "applications",
                  id: 99_999
                }
              }
            }
          }
        }
      ).and_return({ created_comment: "response" })

      result = subject.create_comment_on_application(99_999, "comment")
      expect(result).to eq({ created_comment: "response" })
    end
  end
end
