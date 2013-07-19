ENV['RACK_ENV'] = 'test'

require 'bundler/setup'

require_relative '../lib/dvr'

require_relative 'support/sinatra_app'
require_relative 'support/dvr_localhost_server'

require 'minitest/autorun'
require 'minitest/pride'

module DVR

  SPEC_ROOT= File.dirname(__FILE__)

end

DVR::SinatraApp.boot
