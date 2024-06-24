require "rails_helper"

RSpec.describe WebhooksApplicationHiredJob, type: :job do
  it "retrieves pinpoint application and triggers subsequent jobs" do
    pinpoint_application = { pinpoint: true }

    allow(Pinpoint).to receive(:get_application).with(123).and_return(
      pinpoint_application
    )
    allow(CreateHibobEmployeeJob).to receive(:perform_later)

    WebhooksApplicationHiredJob.perform_now(123)

    expect(CreateHibobEmployeeJob).to have_received(:perform_later).with(
      pinpoint_application
    )
  end
end
