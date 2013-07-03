ENV['RACK_ENV'] = 'test'
require_relative '../lib/dvr'

require 'minitest/autorun'
require 'minitest/pride'

module DVR

  SPEC_ROOT= File.dirname(__FILE__)

end
