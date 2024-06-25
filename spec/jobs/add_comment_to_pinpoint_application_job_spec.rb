require "rails_helper"

RSpec.describe AddCommentToPinpointApplicationJob, type: :job do
  it "creates a comment on an application" do
    allow(Pinpoint).to receive(:create_comment_on_application)

    AddCommentToPinpointApplicationJob.perform_now(12_313_123, 12)

    expect(Pinpoint).to have_received(:create_comment_on_application).with(
      12_313_123,
      "Record created with ID: 12"
    )
  end
end
