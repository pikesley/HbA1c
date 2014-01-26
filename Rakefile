if ENV['RACK_ENV']=='test'
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new
  task :default => [:cucumber]
end

require 'dropbox-api'
require 'dotenv'
require 'json/add/core'
require 'xmlsimple'
require 'yaml'

require 'dropbox-api/tasks'
Dropbox::API::Tasks.install

namespace :export do
  conf = YAML.load File.open 'config/dropbox.yaml'
  data = nil

  desc 'Grab the export.xml file from Dropbox'
  task :acquire do

    Dotenv.load
    Dropbox::API::Config.mode       = 'dropbox'
    Dropbox::API::Config.app_key    = ENV['APP_KEY']
    Dropbox::API::Config.app_secret = ENV['APP_SECRET']

    client = Dropbox::API::Client.new(:token => ENV['TOKEN'], :secret => ENV['SECRET'])

    data = XmlSimple.xml_in (client.download (client.ls(conf['folder']).sort { |x, y| x[:revision] <=> y[:revision] })[-1].path),
                            :ForceArray => false
  end

  desc 'Transform the export.xml file into JSON'
  task :jsonify => :acquire do
    r = data['record']
    r.sort! { |x, y| x['datetime'] <=> y['datetime'] }
    r.each do |entry|
      metric = entry['type'].downcase
      if metric == 'medication'
        metric = entry['subtype'].downcase
      end

      h = {}
      ['datetime', 'category', 'value'].each do |key|
        h[key] = entry[key.to_s]
      end
      j = h.to_json

      command = "curl --silent -X POST -H 'Content-Type: application/json' --basic -u %s:%s -d '%s' %s/metrics/%s" % [
          ENV['METRICS_API_USERNAME'],
          ENV['METRICS_API_PASSWORD'],
          j,
          'https://pancreas-api.herokuapp.com/',
          metric
      ]

      puts command
      `#{command}`
    end
  end
end

#curl -X POST -H "Content-Type: application/json" --basic -u sam:insulin -d '{"datetime":"2014-01-18T07:17:57+00:00","category":"Breakfast","value":"4.5"}' http://localhost:4567/metrics/humalog
