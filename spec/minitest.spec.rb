require_relative 'spec_helper'
require_relative '../lib/dvr/minitest'

describe Minitest do

  before do
    DVR.configure do |c|
      c.service_host    = "http://localhost:#{DVR::SinatraApp.port}"
      c.dvd_library_dir = DVR::SPEC_ROOT + '/fixtures/dvds'
    end
  end

  describe '#assert_dvr_response' do

    it "correctly asserts when response unchanged" do
      assert_dvr_response 'root', url: '/'
    end

    it "returns error message when response not right" do
      ex = ->{ assert_dvr_response 'root', url: '/start-search' }
      .must_raise(Minitest::Assertion)
      msg = "Expected:\n"      +
            "-[\"animals\"]\n" +
            "Actual:\n"        +
            "+[{\"form\"=>[\"action\", \"method\", " +
            "{\"fields\"=>[\"name\", \"type\", \"label\", \"required\"]}]}]"
      ex.message.must_equal msg
    end

  end

end
