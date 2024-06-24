class HibobClient
  def self.post(url, body)
    response =
      HTTP
        .basic_auth(
          user: ENV.fetch("HIBOB_SERVICE_USER_ID"),
          pass: ENV.fetch("HIBOB_SERVICE_USER_PASSWORD")
        )
        .headers(
          { accept: "application/json", content_type: "application/json" }
        )
        .post(url, json: body)

    if !response.status.success?
      raise "Hibob request failed\nURL:#{url}\nCode: #{response.code}\nBody:#{response.body}"
    end

    response.parse
  end
end
