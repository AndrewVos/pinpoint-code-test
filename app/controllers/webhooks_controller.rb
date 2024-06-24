# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    body = JSON.parse(request.body.read)

    if body["event"] == "application_hired"
      head :accepted
      WebhooksApplicationHiredJob.perform_later(body)
    else
      head :bad_request
    end
  end
end
