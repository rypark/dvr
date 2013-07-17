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
      msg = "Unexpected response for root:\n"        +
            "Expected:\n"                            +
            "-[\"animals\"]\n"                       +
            "Actual:\n"                              +
            "+[{\"form\"=>[\"action\", \"method\", " +
            "{\"fields\"=>[\"name\", \"type\", \"label\", \"required\"]}]}]"
      ex.message.must_equal msg
    end

    it "aliases to verify_dvr" do
      verify_dvr 'root', url: '/'
    end

  end

  describe '#assert_all_dvr_response' do

    it 'correctly asserts when response unchanged' do
      assert_all_dvr_response 'api', url: '/api'
    end

    it "returns error message when response not right" do
      ex = ->{ assert_all_dvr_response 'api_with_changes', url: '/api_with_changes'}
      .must_raise(Minitest::Assertion)
      msg = "Unexpected response for changed_form:\n" +
            "Expected:\n"                             +
            "-[\"i_am_different\"]\n"                 +
            "Actual:\n"                               +
            "+[\"required\"]"
      ex.message.must_equal msg
    end

  end

end
