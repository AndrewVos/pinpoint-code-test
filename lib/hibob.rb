class Hibob
  def create_employee(employee)
    HibobClient.post("https://api.hibob.com/v1/people", employee)
  end

  def create_shared_document(employee_id, document_name, document_url)
    HibobClient.post(
      "https://api.hibob.com/v1/docs/people/#{employee_id}/shared",
      { documentName: document_name, documentUrl: document_url }
    )
  end
end
