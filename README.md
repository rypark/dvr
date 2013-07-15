# DVR

Record interactions with services and verify that their json response structure does not change over time.

## Installation

Add this line to your application's Gemfile:

    gem 'dvr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dvr

## Configuration

Requires a bit of simple set up in your {test|spec|whatever}_helper.rb:

```ruby
# Config for a service that uses rack-test
# (This will work for any of our services that use hyper_drive)
DVR.configure do |c|
  c.dvd_library_dir   = 'spec/dvds'
  c.rack_test_service = MyAwesomeService
end

# Config without rack-test
# (Assumes you will manually start the service on the specified service_host)
DVR.configure do |c|
  c.dvd_library_dir = 'spec/dvds'
  c.service_host    = 'http://localhost:9393'
end
```

## Testing

Regardless of testing framework, the command stays the same:

    verify_dvr dvd_name, options

Options are: :url, :params, & :method.

## With RSpec

    require 'dvr/rspec'
    include DVR::RSpecHelpers

## With Minitest

    require 'dvr/minitest'

## Example Usage

```ruby
#Minitest or RSpec require stuff goes here.

describe 'DVR verification' do

  describe 'API responses' do

    it 'returns expected responses' do
      verify_dvr 'root', url: '/'
      verify_dvr 'some_form', url: '/some-form'
      # ...continue through all routes
    end

  end

  describe 'Actions' do

    it 'returns expected responses' do
      verify_dvr 'post-to-some-form',
                 url: '/post-to-some-form',
                 params: {'id' => 1},
                 method: :post
      # ...continue through all actions
    end

  end

end
```
