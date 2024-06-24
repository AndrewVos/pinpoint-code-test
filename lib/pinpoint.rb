require_relative "./pinpoint_client"

class Pinpoint
  def self.get_application(id)
    PinpointClient.get(
      "/api/v1/applications/#{id}?extra_fields[applications]=attachments"
    )
  end

  def self.create_comment_on_application(comment)
    PinpointClient.post(
      "/api/v1/comments",
      {
        data: {
          type: "comments",
          attributes: {
            body_text: comment
          },
          relationships: {
            commentable: {
              data: {
                type: "applications",
                id: ENV.fetch("PINPOINT_APPLICATION_ID").to_i
              }
            }
          }
        }
      }
    )
  end
end
