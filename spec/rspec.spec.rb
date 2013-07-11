require 'rspec'
require_relative 'spec_helper'
require_relative '../lib/dvr/rspec'

describe DVR::RSpecHelpers do

  it 'works' do
    # TODO
    # If anyone can figure out how to test rspec from within minitest,
    # be my guest. Minitest::Spec doesn't seem to work at all (this test is
    # totally ignored currently). Minitest::Test does work, but it doesn't
    # seem to catch on to any additions we attempt to add to RSpec.
  end

end
