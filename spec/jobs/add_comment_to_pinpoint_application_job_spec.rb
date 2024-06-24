require "rails_helper"

RSpec.describe AddCommentToPinpointApplicationJob, type: :job do
  it "creates a comment on an application" do
    allow(Pinpoint).to receive(:create_comment_on_application)

    AddCommentToPinpointApplicationJob.perform_now({ "id" => 12 })

    expect(Pinpoint).to have_received(:create_comment_on_application).with(
      "Record created with ID: 12"
    )
  end
end
