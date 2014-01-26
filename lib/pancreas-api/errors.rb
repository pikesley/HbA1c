class PancreasApi < Sinatra::Base
  def error_406
    content_type 'text/plain'
    error 406, "Not Acceptable"
  end

  def error_400(error)
    content_type 'text/plain'
    error 400, { :status => error }.to_json
  end
end