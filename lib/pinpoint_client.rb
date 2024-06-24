class PinpointClient
  def self.get(path)
    url = "#{ENV.fetch("PINPOINT_DOMAIN")}#{path}"
    response =
      HTTP.headers({ "X-API-KEY" => ENV.fetch("PINPOINT_API_KEY") }).get(url)

    maybe_raise_error(url, response)

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.post(path, body)
    url = "#{ENV.fetch("PINPOINT_DOMAIN")}#{path}"

    response =
      HTTP.headers({ "X-API-KEY" => ENV.fetch("PINPOINT_API_KEY") }).post(
        url,
        json: body
      )

    maybe_raise_error(url, response)

    JSON.parse(response.body, symbolize_names: true)
  end

  private

  def self.maybe_raise_error(url, response)
    if !response.status.success?
      raise "Pinpoint request failed\nURL:#{url}\nCode: #{response.code}\nBody:#{response.body}"
    end
  end
end
