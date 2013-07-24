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

Regardless of testing framework, the commands stay the same:

To verify one action:

    verify_dvr dvd_name, options

To start at an endpoint and verify all links contained within (helpful for starting at the root of a service and following all links):

    verify_all_dvr dvd_name, options

Options are: :url, :params, :method, & :verify_content.
`:url`    - `'/'`, `'/some_resource'`, etc.
`:params` - `{'name' => 'Bro'}`, `{'id' => 1}`, etc.
`:method` - `:get`, `:post`, `:put` (defaults to :get)
`:verify_content` - `true`, `false`

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
      # Will follow and verify all links recursively
      verify_all_dvr 'root', url: '/'
    end

  end

  describe 'Actions' do

    it 'post_to_some_form' do
      verify_dvr 'post-to-some-form',
                 url: '/post-to-some-form',
                 params: {'id' => 1},
                 method: :post
    end

    it 'get_something' do
      verify_dvr 'get_something',
                 url: '/get_something'
    end

    # ...continue through all actions
  end

end
```

## Verifying Content

By default, `verify_dvr` will only check that all keys remain unchanged. If you are testing, say, a form, and need to ensure that the entirety of the content is unchanged, pass the `verify_content: true` option.

In most cases this is unnecessary with `verify_all_dvr`, as it will automatically verify_content any time it encounters a form.
