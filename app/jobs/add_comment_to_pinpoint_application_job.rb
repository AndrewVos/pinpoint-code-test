class AddCommentToPinpointApplicationJob < ApplicationJob
  queue_as :default

  def perform(employee)
    Pinpoint.create_comment_on_application(
      "Record created with ID: #{employee["id"]}"
    )
  end
end
