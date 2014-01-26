require 'sinatra'
require 'haml'
require 'mongoid'
require 'iso8601'
require 'dotenv'
require 'kramdown'
require 'rack/conneg'
require 'rack-google-analytics'

require_relative 'models/metrics'

require_relative 'pancreas-api/helpers'
require_relative 'pancreas-api/racks'
require_relative 'pancreas-api/errors'

Dotenv.load unless ENV['RACK_ENV'] == 'test'
Mongoid.load!(File.expand_path('../mongoid.yml', File.dirname(__FILE__)), ENV['RACK_ENV'])

class PancreasApi < Sinatra::Base

  get '/' do
    respond_to do |wants|
      wants.html {
        haml :index, :locals => {
            :title           => 'pancreas-api',
            :text            => 'pancreas-api',
            :bootstrap_theme => '../lavish-bootstrap.css',
            :github          => {
                :user    => 'pikesley',
                :project => 'HbA1c',
                :ribbon  => 'right_gray_6d6d6d'
            }
        }
      }
      wants.other { error_406 }
    end
  end

  post '/metrics/:metric' do
    protected!

    j        = JSON.parse request.body.read
    j[:name] = params[:metric]

    if lookup(j).first
      if lookup(j).update value: j['value']
        return 201
      else
        return 500
      end

    else

      @metric = Metric.new j

      if @metric.save
        return 201
      else
        return 500
      end
    end
  end

  get '/metrics' do
    protected!

    data = {
        'metrics' => Metric.all.distinct(:name).sort.map do |name|
          {
              name: name,
              url:  'https://%s/metrics/%s' % [
                  request.host,
                  name
              ]
          }
        end
    }

    respond_to do |wants|
      wants.json { data.to_json }
      wants.other { error_406 }
    end
  end

  get '/metrics/:metric' do
    protected!

    @metric = Metric.where(name: params[:metric]).order_by(:datetime.asc).last
    respond_to do |wants|
      wants.json { @metric.to_json }
      wants.other { error_406 }
    end
  end

  get '/metrics/:metric/:datetime' do
    protected!

    time = DateTime.parse(params[:datetime]) rescue
        error_400("'%s' is not a valid ISO8601 date/time." % params[:datetime])

    @metric = Metric.where(
        name: params[:metric],
        :datetime.lte => time
    ).order_by(:datetime.asc).last

    respond_to do |wants|
      wants.json { @metric.to_json }
      wants.other { error_406 }
    end
  end

  get '/metrics/:metric/:from/:to' do
    protected!

    start_date = DateTime.parse(params[:from]) rescue nil
    end_date = DateTime.parse(params[:to]) rescue nil

    if params[:from] =~ /^P/
      start_date = end_date - ISO8601::Duration.new(params[:from]).to_seconds.seconds rescue error_400("'#{params[:from]}' is not a valid ISO8601 duration.")
    end

    if params[:to] =~ /^P/
      end_date = start_date + ISO8601::Duration.new(params[:to]).to_seconds.seconds rescue error_400("'#{params[:to]}' is not a valid ISO8601 duration.")
    end

    invalid = []

    invalid << "'#{params[:from]}' is not a valid ISO8601 date/time." if start_date.nil? && params[:from] != "*"
    invalid << "'#{params[:to]}' is not a valid ISO8601 date/time." if end_date.nil? && params[:to] != "*"

    error_400(invalid.join(" ")) unless invalid.blank?

    if start_date != nil && end_date != nil
      error_400("'from' date must be before 'to' date.") if start_date > end_date
    end

    metrics = Metric.where(:name => params[:metric])
    metrics = metrics.where(:datetime.gte => start_date) if start_date
    metrics = metrics.where(:datetime.lte => end_date) if end_date

    metrics = metrics.order_by(:datetime.asc)

    data = {
        :count  => metrics.count,
        :values => []
    }

    metrics.each do |metric|
      data[:values] << {
          :datetime => metric.datetime,
          :value    => metric.value,
          :category => metric.category
      }
    end

    respond_to do |wants|
      wants.json { data.to_json }
      wants.other { error_406 }
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end


