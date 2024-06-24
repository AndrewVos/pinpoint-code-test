# frozen_string_literal: true

require_relative "../../lib/pinpoint"
require_relative "../../lib/hibob"

class WebhooksApplicationHiredJob < ApplicationJob
  queue_as :default

  def perform(event)
    application_id = event.fetch("data").fetch("application").fetch("id")

    pinpoint_api = Pinpoint.new
    pinpoint_application = pinpoint_api.get_application(application_id)

    pinpoint_pdf =
      pinpoint_application["data"]["attributes"][
        "attachments"
      ].find { |attachment| attachment["context"] == "pdf_cv" }

    hibob = Hibob.new

    hibob_employee = {
      email: pinpoint_application["data"]["attributes"]["email"],
      firstName: pinpoint_application["data"]["attributes"]["first_name"],
      surname: pinpoint_application["data"]["attributes"]["last_name"],
      work: {
        site: ENV.fetch("HIBOB_WORK_SITE"),
        startDate: 1.week.from_now.to_date
      }
    }

    create_employee_response = hibob.create_employee(hibob_employee)

    create_shared_document_response =
      hibob.create_shared_document(
        create_employee_response["id"],
        pinpoint_pdf["filename"],
        pinpoint_pdf["url"]
      )

    pinpoint_api.create_comment_on_application(
      "Record created with ID: #{create_employee_response["id"]}"
    )
  end
end
