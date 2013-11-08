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
      config.password = "password"
      config.licence = "licencenu"
    end
    #Get API key
    TopsyApi.configure.api_key = "API KEY"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
