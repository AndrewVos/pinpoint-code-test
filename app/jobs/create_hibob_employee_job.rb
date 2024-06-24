class CreateHibobEmployeeJob < ApplicationJob
  queue_as :default

  def perform(pinpoint_application)
    employee =
      Hibob.create_employee(
        {
          email: pinpoint_application[:data][:attributes][:email],
          firstName: pinpoint_application[:data][:attributes][:first_name],
          surname: pinpoint_application[:data][:attributes][:last_name],
          work: {
            site: ENV.fetch("HIBOB_WORK_SITE"),
            startDate: 1.week.from_now.to_date
          }
        }
      )

    CreateHibobSharedDocumentJob.perform_later(pinpoint_application, employee)
    AddCommentToPinpointApplicationJob.perform_later(employee)
  end
end
