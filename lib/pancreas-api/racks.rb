class PancreasApi < Sinatra::Base
  use Rack::GoogleAnalytics, :tracker => 'UA-47486297-1'

  use(Rack::Conneg) do |conneg|
    conneg.set :accept_all_extensions, false
    conneg.set :fallback, :html
    conneg.provide([:json])
  end

  before do
    if negotiated?
      content_type negotiated_type
    end
  end
end