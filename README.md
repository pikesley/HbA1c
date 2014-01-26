[![Build Status](http://b.adge.me/travis/pikesley/HbA1c.svg)](https://travis-ci.org/pikesley/HbA1c)
[![Coverage Status](http://b.adge.me/coveralls/pikesley/HbA1c.svg)](https://coveralls.io/r/pikesley/HbA1c)
[![Dependency Status](http://b.adge.me/gemnasium/pikesley/HbA1c.svg)](https://gemnasium.com/pikesley/HbA1c)
[![Code Climate](http://b.adge.me/codeclimate/github/pikesley/HbA1c.svg)](https://codeclimate.com/github/pikesley/HbA1c)
[![License](http://b.adge.me/:license-mit-green.svg)](http://pikesley.mit-license.org/)

# HbA1c

## Just because my pancreas is broken, doesn't mean it can't have a RESTful API

I collect blood-glucose and medication data with [this](http://www.medivo.com/ontrack/). It can export XML and push it straight into Dropbox. Let's make an API! Let's make a dashboard! _Let's have badges!_

## The ODI's metrics-api

So we built [this thing](https://metrics.theodi.org/) at the [Open Data Institute](http://theodi.org), which already does quite a lot of what I want. I forked it and spent the recent [Real Food Hack](http://lanyrd.com/2014/real-food-hack/) weekend bending it to my will. I've just got it cooking on Heroku, and I'll document the full API when I've nailed it down.

## Rake task

Right now I have a (shittily-named, now I think about it) Rake task:

    rake export:jsonify
    
which grabs the newest file from a Dropbox folder called _ontrack/_ (configurable in _config/dropbox.yaml_), parses it into JSON, and rams it through my API. Using cURL. And currently running only off my Mac. Man, this bit it such a hack. 

Anyway, I'll clean that up and get it running as a Heroku worker task thingy sometime. 

## Setting it up

You need Ruby 2.1.0 installed. Now:

    git clone https://github.com/pikesley/HbA1c
    cd HbA1c
    bundle
       
### Heroku FTW

You'll need a working Heroku configuration, which [is pretty damned easy](https://devcenter.heroku.com/articles/quickstart).

Now create a Heroku app (called something other than _pancreas_api_, I already claimed that):

    ➔ heroku apps:create pancreas-api --region eu
    Creating pancreas-api... done, region is eu
    http://pancreas-api.herokuapp.com/ | git@heroku.com:pancreas-api.git
    Git remote heroku added

Heroku have at least 2 MongoDB add-on services. MongoHQ is _really_ slick, but it's not currently available in the EU region, so let's use Mongolabs instead:

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
    MONGOLAB_URI: mongodb://hba1c: i_r_secure_password@ds063158.mongolab.com:63158/heroku_app21605738

If you look at _mongoid.yml_, you'll see this:

    production: 
      sessions:
        default:
          uri: <%= ENV['MONGOLAB_URI'] %>
          
So because this stuff is all made of magic, this will now work.



For the Dropbox bit, you need a Dropbox API key and secret from [here](https://www.dropbox.com/developers/apps), then the [dropbox-api](https://github.com/futuresimple/dropbox-api) gem comes with a splendid Rake task

    rake dropbox:authorize

to do the Oauth manoeuvres and get the token and secret for you. Put these in _.env_ (see _.env.example_) and you should be good to go.


## Next steps

From here, it's a short hop to a beautiful [Dashing](http://shopify.github.io/dashing/) dashboard, I expect.
