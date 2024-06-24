class HiBobApi
  def create_employee(employee)
    response =
      HTTP
        .basic_auth(
          user: ENV.fetch("HIBOB_SERVICE_USER_ID"),
          pass: ENV.fetch("HIBOB_SERVICE_USER_PASSWORD")
        )
        .headers(
          { accept: "application/json", content_type: "application/json" }
        )
        .post("https://api.hibob.com/v1/people", json: employee)

    if !response.status.success?
      raise "Failed to create employee: #{response.body}"
    end

    response.parse
  end

  def create_shared_document(employee_id, document_name, document_url)
    response =
      HTTP
        .basic_auth(
          user: ENV.fetch("HIBOB_SERVICE_USER_ID"),
          pass: ENV.fetch("HIBOB_SERVICE_USER_PASSWORD")
        )
        .headers(
          { accept: "application/json", content_type: "application/json" }
        )
        .post(
          "https://api.hibob.com/v1/docs/people/#{employee_id}/shared",
          json: {
            documentName: document_name,
            documentUrl: document_url
          }
        )

    if !response.status.success?
      raise "Failed to create shared document: #{response.body}"
    end

    response.parse
  end
end
