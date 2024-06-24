# frozen_string_literal: true

require_relative "../../lib/pinpoint"
require_relative "../../lib/hibob"

class WebhooksApplicationHiredJob < ApplicationJob
  queue_as :default

  def perform(pinpoint_application_id)
    pinpoint_application = Pinpoint.get_application(pinpoint_application_id)

    CreateHibobEmployeeJob.perform_later(pinpoint_application)
  end
end
