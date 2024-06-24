class CreateHibobSharedDocumentJob < ApplicationJob
  queue_as :default

  def perform(pinpoint_application, employee)
    pinpoint_pdf =
      pinpoint_application[:data][:attributes][
        :attachments
      ].find { |attachment| attachment[:context] == "pdf_cv" }

    Hibob.create_shared_document(
      employee[:id],
      pinpoint_pdf[:filename],
      pinpoint_pdf[:url]
    )
  end
end
