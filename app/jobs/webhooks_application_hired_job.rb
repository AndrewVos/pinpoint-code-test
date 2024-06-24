# frozen_string_literal: true

class PinpointApi
  def get_application(id)
    response =
      HTTP.headers({ "X-API-KEY" => ENV.fetch("PINPOINT_API_KEY") }).get(
        "#{ENV.fetch("PINPOINT_DOMAIN")}/api/v1/applications/#{id}?extra_fields[applications]=attachments"
      )
    JSON.parse(response)
  end

  def create_comment_on_application(comment)
    response =
      HTTP.headers({ "X-API-KEY" => ENV.fetch("PINPOINT_API_KEY") }).post(
        "#{ENV.fetch("PINPOINT_DOMAIN")}/api/v1/comments",
        json: {
          data: {
            type: "comments",
            attributes: {
              body_text: comment
            },
            relationships: {
              commentable: {
                data: {
                  type: "applications",
                  id: ENV.fetch("PINPOINT_APPLICATION_ID")
                }
              }
            }
          }
        }
      )

    if !response.status.success?
      raise "Failed to create comment on application: #{response.body}"
    end

    JSON.parse(response)
  end
end

class HiBobApi
  def create_employee(employee)
    response =
      HTTP
        .basic_auth(
          user: ENV.fetch("HIBOB_SERVICE_USER_ID"),
          pass: ENV.fetch("HIBOB_SERVICE_USER_PASSWORD")
        )
        .headers(
          { accept: "application/json", content_type: "application/json" }
        )
        .post("https://api.hibob.com/v1/people", json: employee)

    if !response.status.success?
      raise "Failed to create employee: #{response.body}"
    end

    response.parse
  end

  def create_shared_document(employee_id, document_name, document_url)
    response =
      HTTP
        .basic_auth(
          user: ENV.fetch("HIBOB_SERVICE_USER_ID"),
          pass: ENV.fetch("HIBOB_SERVICE_USER_PASSWORD")
        )
        .headers(
          { accept: "application/json", content_type: "application/json" }
        )
        .post(
          "https://api.hibob.com/v1/docs/people/#{employee_id}/shared",
          json: {
            documentName: document_name,
            documentUrl: document_url
          }
        )

    if !response.status.success?
      raise "Failed to create shared document: #{response.body}"
    end

    response.parse
  end
end

class WebhooksApplicationHiredJob < ApplicationJob
  queue_as :default

  def perform(event)
    application_id = event.fetch("data").fetch("application").fetch("id")

    pinpoint_api = PinpointApi.new
    pinpoint_application = pinpoint_api.get_application(application_id)

    pinpoint_pdf =
      pinpoint_application["data"]["attributes"][
        "attachments"
      ].find { |attachment| attachment["context"] == "pdf_cv" }

    hibob_api = HiBobApi.new

    hibob_employee = {
      email: pinpoint_application["data"]["attributes"]["email"],
      firstName: pinpoint_application["data"]["attributes"]["first_name"],
      surname: pinpoint_application["data"]["attributes"]["last_name"],
      work: {
        site: ENV.fetch("HIBOB_WORK_SITE"),
        startDate: 1.week.from_now.to_date
      }
    }

    create_employee_response = hibob_api.create_employee(hibob_employee)

    create_shared_document_response =
      hibob_api.create_shared_document(
        create_employee_response["id"],
        pinpoint_pdf["filename"],
        pinpoint_pdf["url"]
      )

    pinpoint_api.create_comment_on_application(
      "Record created with ID: #{create_employee_response["id"]}"
    )
  end
end
