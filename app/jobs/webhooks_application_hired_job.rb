# frozen_string_literal: true

require_relative "../../lib/pinpoint"
require_relative "../../lib/hibob"

class WebhooksApplicationHiredJob < ApplicationJob
  queue_as :default

  def perform(event)
    application_id = event.fetch(:data).fetch(:application).fetch(:id)
    pinpoint_application = Pinpoint.get_application(application_id)

    CreateHibobEmployeeJob.perform_later(pinpoint_application)
  end
end
