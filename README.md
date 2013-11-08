# TopsyApi

Topsy API integration

## Installation

Add this line to your application's Gemfile:

    gem 'topsy_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install topsy_api

## Usage

### Configure Topsy
    TopsyApi.configure do |config|
      config.api_key = "API KEY"
    end

    client = TopsyApi::Client.new
    # Get tweets [http://api.topsy.com/doc/resources/content/tweets/]
    # options like {"offset"=>1,"limit"=>1,"include_metrics"=>0,"include_enrichment_all"=>0,"new_only"=>0,:sort_by=>''}

    client.tweets(keywords,options={})

    # Bulk Tweet [http://api.topsy.com/doc/resources/content/bulktweets/]
      client.bulk_tweets(keywords,options={})

    # Links [http://api.topsy.com/doc/resources/content/links/]
      client.links(keywords,options={})  

    # Photos [http://api.topsy.com/doc/resources/content/photos/]
      client.photos(keywords,options={})    

    # Videos [http://api.topsy.com/doc/resources/content/videos/]
      client.videos(keywords,options={})    

    # Citations [http://api.topsy.com/doc/resources/content/citations/]
      client.citations(url,options={})    

    # Conversation [http://api.topsy.com/doc/resources/content/conversation/]
      client.conversations(url)      

    # Stremaing [http://api.topsy.com/doc/resources/content/streaming/]
    # options {:include_enrichment_all"=>0,"sample"=>0}
      client.streaming(keywords,options={})

    # Tweet [http://api.topsy.com/doc/resources/content/tweet/]  
      client.tweet(postids)

    # Validate [http://api.topsy.com/doc/resources/content/validate/]  
      client.validate(postids)  

    # Location [http://api.topsy.com/doc/resources/content/location/]  
    # types may be of country, state, county, city
      client.location(location,types=nil)    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
