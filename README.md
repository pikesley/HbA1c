[![Build Status](http://b.adge.me/travis/pikesley/HbA1c.svg)](https://travis-ci.org/pikesley/HbA1c)
[![Coverage Status](http://b.adge.me/coveralls/pikesley/HbA1c.svg)](https://coveralls.io/r/pikesley/HbA1c)
[![Dependency Status](http://b.adge.me/gemnasium/pikesley/HbA1c.svg)](https://gemnasium.com/pikesley/HbA1c)
[![Code Climate](http://b.adge.me/codeclimate/github/pikesley/HbA1c.svg)](https://codeclimate.com/github/pikesley/HbA1c)
[![License](http://b.adge.me/:license-mit-green.svg)](http://pikesley.mit-license.org/)

# HbA1c

## Just because my pancreas is broken, doesn't mean it can't have a RESTful API

_v0.0.1_

I've [broken](http://uncleclive.herokuapp.com/) the [chain](https://pokrovsky.herokuapp.com/) and built something that _might actually be useful_. So:

I collect blood-glucose and medication data with [this](http://www.medivo.com/ontrack/). It can export XML and push it straight into Dropbox. Let's make an API! Let's make a dashboard! _Let's have badges!_

## The ODI's metrics-api

We built [this thing](https://metrics.theodi.org/) at the [Open Data Institute](http://theodi.org), which already does quite a lot of what I want. I forked it and spent the recent [Real Food Hack](http://lanyrd.com/2014/real-food-hack/) weekend bending it to my will.

## API

###Fetching data

All requests should include `Accept: application/json`, and provide basic auth credentials, e.g.

    curl -X GET -H 'Accept: application/json' --basic -u user:password https://pancreas-api.herokuapp.com/metrics/glucose

#### `GET https://pancreas-api.herokuapp.com/metrics`

Fetches list of available metrics

#### `GET https://pancreas-api.herokuapp.com/metrics/{metric_name}`

Fetches latest value for specified metric

#### `GET https://pancreas-api.herokuapp.com/metrics/{metric_name}/{time}`

Fetch the most recent value of the metric at the specified time, where time is an ISO8601 date/time

#### `GET https://pancreas-api.herokuapp.com/metrics/{metric_name}/{from}/{to}`

Fetch all values of the metric between the specified times. from and to can be either:

* An ISO8601 date/time
* An ISO8601 duration
* *, meaning unspecified

### Adding data

#### `POST https://pancreas-api.herokuapp.com/metrics/{metric-name}`

All requests should include `Content-type: application/json`, and provide basic auth credentials, and a JSON payload like:

    {
      "datetime": "{iso8601-date-time}",
      "category": "{category}"
      "value": "{value}"
    }

where

* `category` is one of
  * `Breakfast`
  * `After breakfast`
  * etc
* `value` is a Float, with
  * medication metrics assumed to have units of [Insulin Units](http://en.wikipedia.org/wiki/Insulin_therapy#The_dosage_units)
  * glucose metrics assumed to have units of _mmol/L_

## Setting it up

You need Ruby 2.1.0 installed. Now:

    git clone https://github.com/pikesley/HbA1c
    cd HbA1c
    bundle
       
### Heroku FTW

You'll need a working Heroku configuration, which [is pretty damned easy](https://devcenter.heroku.com/articles/quickstart) these days.

Now create a Heroku app (called something other than _pancreas_api_, I already claimed that):

    ➔ heroku apps:create pancreas-api --region eu
    Creating pancreas-api... done, region is eu
    http://pancreas-api.herokuapp.com/ | git@heroku.com:pancreas-api.git
    Git remote heroku added

Heroku have at least 2 MongoDB add-on services. MongoHQ is _really_ slick, but it's not currently available in the EU region, so let's use Mongolab instead:

    ➔ heroku addons:add mongolab
    Adding mongolab on pancreas-api... done, v3 (free)
    Welcome to MongoLab.  Your new subscription is being created and will be available shortly.  Please consult the MongoLab Add-on Admin UI to check on its progress.
    Use `heroku addons:docs mongolab` to view documentation

Now there's some manual fiddling to set up a DB user, so do

    heroku addons:open mongolab
    
There should see your new database; create a user and password on it. Then bring those creds back to your shell:

    ➔ MONGOLAB_USER=hba1c
    ➔ MONGOLAB_PASS=i_r_secure_password
    ➔ heroku config:set MONGOLAB_URI="mongodb://${MONGOLAB_USER}:${MONGOLAB_PASS}@ds063158.mongolab.com:63158/heroku_app21605738"
    Setting config vars and restarting pancreas-api... done, v4
    MONGOLAB_URI: mongodb://hba1c:i_r_secure_password@ds063158.mongolab.com:63158/heroku_app21605738

If you look at _mongoid.yml_, you'll see this:

    production: 
      sessions:
        default:
          uri: <%= ENV['MONGOLAB_URI'] %>
          
So because this stuff is all made of magic, this will now work.

### Dropbox integration

For the Dropbox bit, you need a Dropbox API key and secret from [here](https://www.dropbox.com/developers/apps), then the [dropbox-api](https://github.com/futuresimple/dropbox-api) gem comes with a splendid Rake task

    rake dropbox:authorize

to do the Oauth manoeuvres and get the token and secret for you. Put these in _.env_ like this. And while you're at it, choose a login and password for the API (which you'll use to GET and POST data):

    DROPBOX_APP_KEY: ive_got_the_key
    DROPBOX_APP_SECRET: ive_got_the_secret
    DROPBOX_TOKEN: i_also_have_a_token
    DROPBOX_SECRET: and_another_secret
    METRICS_API_USERNAME: hba1c
    METRICS_API_PASSWORD: ifyouusethispasswordbadthingswillhappen

Now you need to set these in the Heroku environment as well. Here's an ugly hack to do just that thing:

    for line in `cat .env` ; do heroku config:set `echo ${line} | sed "s/: /=/"` ; done
    
Time to push the code to Heroku:

    git push heroku master

And see if it worked:

    heroku open
    
 You should now be looking at, erm, this README
    
### Import some data

We'll use the Heroku scheduler to run the data import job, but let's test that first. Do a data export from OnTrack:

* Yes, you want to 'email' it
* Into a Dropbox directory called _ontrack_
* As XML

Now

    heroku run RACK_ENV=production bundle exec rake export:jsonify

(Yes, that's a shittly-named task. Also that job currently has _no tests_, and I know of at least one bug in the importer. And it's shelling out to cURL. This is not my best work).

Anyway, you _should_ see a load of curl lines whizzing past, and when it's finished, some data should have been imported. You can test it with something like:

    curl -X GET -H 'Accept: application/json' --basic -u user:password https://pancreas-api.herokuapp.com/metrics/glucose

which should return some JSON for the latest blood-glucose event.

### Heroku scheduler

This task would obviously be better handled by a robot:

    heroku addons:add scheduler
    heroku addons:open scheduler

Add a new task, `bundle exec rake export:jsonify`, to run once a day.

And that's that.

## Dashboard

The obvious next step is to put a [beautiful Dashing dashboard](https://github.com/pikesley/diabetes-dashboard) on the front of this.
