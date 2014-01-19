# HbA1c

## Just because my pancreas is broken, doesn't mean it can't have a RESTful API

I collect blood-glucose and medication data with [this](http://www.medivo.com/ontrack/). It can export XML and push it straight into Dropbox. Let's make an API! Let's make a dashboard! _Let's have badges!_

Right now it's just a (shittily-named, now I think about it) Rake task:

    rake export:jsonify
    
which grabs the newest file from a Dropbox folder called _ontrack/_ (configurable in _config/dropbox.yaml_), and parses it into some nice JSON, which I'm intending to poke into [MongoDB](http://www.mongodb.org/).

## Setting it up

    git clone https://github.com/pikesley/HbA1c
    cd HbA1c
    bundle
   
(expects Ruby 2.1.0)

You need a Dropbox API key and secret from [here](https://www.dropbox.com/developers/apps), then the [dropbox-api](https://github.com/futuresimple/dropbox-api) gem comes with a splendid Rake task

    rake dropbox:authorize

to do the Oauth manoeuvres and get the token and secret for you. Put these in _.env_ (see _.env.example_) and you should be good to go.

## Next steps

How hard can it be to wrap a RESTful API around MongoDB using [Sinatra](http://www.sinatrarb.com/)? It's already JSON, right?

And from there, it's a short hop to a beautiful [Dashing](http://shopify.github.io/dashing/) dashboard, I expect.
