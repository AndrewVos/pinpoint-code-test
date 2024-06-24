# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    body = JSON.parse(request.body.read)
    event = body["event"]

    raise "Invalid event #{event}" unless event == "application_hired"

    WebhooksApplicationHiredJob.perform_later(body)
  end
end
