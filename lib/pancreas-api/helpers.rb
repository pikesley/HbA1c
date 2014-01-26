class PancreasApi < Sinatra::Base
  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and
          @auth.basic? and
          @auth.credentials and
          @auth.credentials == [
              ENV['METRICS_API_USERNAME'],
              ENV['METRICS_API_PASSWORD']
          ]
    end
  end

  def lookup item
    Metric.where(
        :datetime => DateTime.parse(item['datetime']),
        :name     => item[:name]
    )
  end

  def get_duration interval
    ISO8601::Duration.new(interval).to_seconds.seconds rescue
        error_400("'%s' is not a valid ISO8601 duration." % interval)
  end
end