# frozen_string_literal: true

require "http"

return if !Rails.env.development?

def find_employee(email)
  response =
    HTTP
      .basic_auth(
        user: ENV.fetch("HIBOB_SERVICE_USER_ID"),
        pass: ENV.fetch("HIBOB_SERVICE_USER_PASSWORD")
      )
      .headers({ accept: "application/json", content_type: "application/json" })
      .post(
        "https://api.hibob.com/v1/people/#{Rack::Utils.escape(email)}",
        json: {
          fields: ["ID"]
        }
      )

  return nil if response.code == 404
  return response.parse if response.status.success?
  raise "Failed to find employee: #{response.body}"
end

def update_employee_email(id, new_email)
  response =
    HTTP
      .basic_auth(
        user: ENV.fetch("HIBOB_SERVICE_USER_ID"),
        pass: ENV.fetch("HIBOB_SERVICE_USER_PASSWORD")
      )
      .headers({ accept: "application/json" })
      .put(
        "https://api.hibob.com/v1/people/#{id}/email",
        json: {
          email: new_email
        }
      )

  if !response.status.success?
    raise "Failed to update employee email: #{response.body}"
  end

  response.status.success?
end

namespace :webhooks do
  desc "test the application_hired webhook"
  task :application_hired do
    # clean up employees that have been created by this test
    existing_employee = find_employee("williams.lockman@pinpoint.dev")
    if existing_employee.present?
      # update employee email to something random so
      # that we can do this test again
      update_employee_email(
        existing_employee["id"],
        "#{SecureRandom.uuid}@example.org"
      )
    end

    response =
      HTTP.post(
        "http://localhost:3000/webhooks",
        json: {
          event: "application_hired",
          triggeredAt: 1_614_687_278,
          data: {
            application: {
              id: ENV.fetch("PINPOINT_APPLICATION_ID")
            },
            job: {
              id: 1
            }
          }
        }
      )

    puts response.body.to_s
  end
end
