# Dvr

Record interactions with services and verify that their json response structure does not change over time.

## Installation

Add this line to your application's Gemfile:

    gem 'dvr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dvr

## Usage
```ruby
DVR.configure do |c|
  c.dvd_library_dir = 'spec/dvds'
  c.service_host    = 'http://localhost:9393'
end

# Args are: dvd file name, followed by options.
# (url, params, method)
DVR.verify('root', url: '/').must_equal true

# with params:
search = FactoryGirl.create(:search)
DVR.verify('receive-results', url: '/receive-results', params: {id: search.id}).must_equal true

# post:
DVR.verify('start-search', url: '/start-search', method: :post).must_equal true
````
