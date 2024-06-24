class Pinpoint
  def get_application(id)
    response =
      HTTP.headers({ "X-API-KEY" => ENV.fetch("PINPOINT_API_KEY") }).get(
        "#{ENV.fetch("PINPOINT_DOMAIN")}/api/v1/applications/#{id}?extra_fields[applications]=attachments"
      )

    if !response.status.success?
      raise "Failed to get application: #{response.body}"
    end

    JSON.parse(response)
  end

  def create_comment_on_application(comment)
    response =
      HTTP.headers({ "X-API-KEY" => ENV.fetch("PINPOINT_API_KEY") }).post(
        "#{ENV.fetch("PINPOINT_DOMAIN")}/api/v1/comments",
        json: {
          data: {
            type: "comments",
            attributes: {
              body_text: comment
            },
            relationships: {
              commentable: {
                data: {
                  type: "applications",
                  id: ENV.fetch("PINPOINT_APPLICATION_ID")
                }
              }
            }
          }
        }
      )

    if !response.status.success?
      raise "Failed to create comment on application: #{response.body}"
    end

    JSON.parse(response)
  end
end
