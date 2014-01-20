[![Build Status](http://b.adge.me/travis/pikesley/HbA1c.svg)](https://travis-ci.org/pikesley/HbA1c)
[![Coverage Status](http://b.adge.me/coveralls/pikesley/HbA1c.svg)](https://coveralls.io/r/pikesley/HbA1c)
[![Dependency Status](https://gemnasium.com/pikesley/HbA1c.png)](https://gemnasium.com/pikesley/HbA1c)
[![Code Climate](https://codeclimate.com/github/pikesley/HbA1c.png)](https://codeclimate.com/github/pikesley/HbA1c)
[![License](http://b.adge.me/:license-mit-green.svg)](http://pikesley.mit-license.org/)

# HbA1c

## Just because my pancreas is broken, doesn't mean it can't have a RESTful API

I collect blood-glucose and medication data with [this](http://www.medivo.com/ontrack/). It can export XML and push it straight into Dropbox. Let's make an API! Let's make a dashboard! _Let's have badges!_

## The ODI's metrics-api

So we built [this thing](https://metrics.theodi.org/) at the [Open Data Institute](http://theodi.org), which already does quite a lot of what I want. I forked it and spent the recent [Real Food Hack](http://lanyrd.com/2014/real-food-hack/) weekend bending it to my will. I've just got it cooking on Heroku, and I'll document the full API when I've nailed it down.

## Rails task

Right now I have a (shittily-named, now I think about it) Rake task:

    rake export:jsonify
    
which grabs the newest file from a Dropbox folder called _ontrack/_ (configurable in _config/dropbox.yaml_), parses it into JSON, and rams it through my API. Using cURL. And currently running only off my Mac. Man, this bit it such a hack. 

Anyway, I'll clean that up and get it running as a Heroku worker task thingy sometime. 

## Setting it up

    git clone https://github.com/pikesley/HbA1c
    cd HbA1c
    bundle
   
(expects Ruby 2.1.0)

For the Dropbox bit, you need a Dropbox API key and secret from [here](https://www.dropbox.com/developers/apps), then the [dropbox-api](https://github.com/futuresimple/dropbox-api) gem comes with a splendid Rake task

    rake dropbox:authorize

to do the Oauth manoeuvres and get the token and secret for you. Put these in _.env_ (see _.env.example_) and you should be good to go.

Actually running the app requires some more docs which I'm not going to write now.

## Next steps

From here, it's a short hop to a beautiful [Dashing](http://shopify.github.io/dashing/) dashboard, I expect.
