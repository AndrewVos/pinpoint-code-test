require "rails_helper"

RSpec.describe Hibob do
  let(:subject) { described_class }

  before do
    allow(ENV).to receive(:fetch).with("HIBOB_SERVICE_USER_ID").and_return(
      "user"
    )
    allow(ENV).to receive(:fetch).with(
      "HIBOB_SERVICE_USER_PASSWORD"
    ).and_return("password")
  end

  describe "#create_employee" do
    let (:employee) do
      {
        email: "example@email.com",
        firstName: "first",
        surname: "last",
        work: {
          site: "Example Site",
          startDate: Date.today
        }
      }
    end

    it "returns the created employee" do
      allow(HibobClient).to receive(:post).with(
        "https://api.hibob.com/v1/people",
        employee
      ).and_return({ created: "response" })

      expect(subject.create_employee(employee)).to eq({ created: "response" })
    end
  end

  describe "#create_shared_document" do
    let (:employee_id) {
      "123"
    }
    let (:document_name) {
      "document"
    }
    let(:document_url) { "url" }

    it "creates a shared document for an employee" do
      allow(HibobClient).to receive(:post).with(
        "https://api.hibob.com/v1/docs/people/#{employee_id}/shared",
        { documentName: document_name, documentUrl: document_url }
      ).and_return({ created_document: "response" })

      expect(
        subject.create_shared_document(employee_id, document_name, document_url)
      ).to eq({ created_document: "response" })
    end
  end
end
