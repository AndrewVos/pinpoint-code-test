# frozen_string_literal: true

require "http"

if !Rails.env.development?
  abort("This task can only be executed in development mode")
end

namespace :webhooks do
  desc "test the application_hired webhook"
  task :application_hired do
    response =
      HTTP.post(
        "http://localhost:3000/webhooks",
        json: {
          event: "application_hired",
          triggeredAt: 1_614_687_278,
          data: {
            application: {
              id: 1
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
