require "rails_helper"

RSpec.describe CreateHibobSharedDocumentJob, type: :job do
  it "creates a hibob shared document" do
    allow(Hibob).to receive(:create_shared_document)

    CreateHibobSharedDocumentJob.perform_now(
      {
        data: {
          attributes: {
            attachments: [
              {
                context: "pdf_cv",
                filename: "file.pdf",
                url: "http://example.com/pdf.cv"
              }
            ]
          }
        }
      },
      { id: 12 }
    )

    expect(Hibob).to have_received(:create_shared_document).with(
      12,
      "file.pdf",
      "http://example.com/pdf.cv"
    )
  end
end
