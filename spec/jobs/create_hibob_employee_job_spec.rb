require "rails_helper"

RSpec.describe CreateHibobEmployeeJob, type: :job do
  before do
    allow(ENV).to receive(:fetch).with("HIBOB_WORK_SITE").and_return("site")
    allow(Hibob).to receive(:create_employee).and_return(employee)

    allow(CreateHibobSharedDocumentJob).to receive(:perform_later)
    allow(AddCommentToPinpointApplicationJob).to receive(:perform_later)
  end

  let(:employee) { double(:employee) }
  let(:pinpoint_application) do
    {
      data: {
        attributes: {
          email: "email@",
          first_name: "first",
          last_name: "last"
        }
      }
    }
  end

  it "creates a hibob employee" do
    CreateHibobEmployeeJob.perform_now(pinpoint_application)

    expect(Hibob).to have_received(:create_employee).with(
      {
        email: "email@",
        firstName: "first",
        surname: "last",
        work: {
          site: "site",
          startDate: 1.week.from_now.to_date
        }
      }
    )
  end

  it "triggers subsequent jobs" do
    CreateHibobEmployeeJob.perform_now(pinpoint_application)

    expect(CreateHibobSharedDocumentJob).to have_received(:perform_later).with(
      pinpoint_application,
      employee
    )
    expect(AddCommentToPinpointApplicationJob).to have_received(
      :perform_later
    ).with(employee)
  end
end
