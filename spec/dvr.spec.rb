require_relative 'spec_helper'

describe DVR do

  describe ".verify" do

    before do
      DVR.configure do |c|
        c.service_host    = "http://localhost:#{DVR::SinatraApp.port}"
        c.dvd_library_dir = DVR::SPEC_ROOT + '/fixtures/dvds'
      end
    end

    it "returns true when no changes" do
      DVR.verify('root', url: '/').must_equal true
    end

    it "returns error message when there are changes" do
      -> {DVR.verify('example', url: '/').must_equal true}
      .must_raise(Minitest::Assertion)
    end

  end

end
