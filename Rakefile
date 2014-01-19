require 'cucumber/rake/task'

Cucumber::Rake::Task.new

task :default => [:cucumber]


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
#      puts JSON.pretty_generate entry
      puts entry
#      puts '---'
    end
  end
end

