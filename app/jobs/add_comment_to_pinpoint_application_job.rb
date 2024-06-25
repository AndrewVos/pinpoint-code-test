class AddCommentToPinpointApplicationJob < ApplicationJob
  queue_as :default

  def perform(pinpoint_application_id, employee_id)
    Pinpoint.create_comment_on_application(
      pinpoint_application_id,
      "Record created with ID: #{employee_id}"
    )
  end
end
