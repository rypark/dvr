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
      -> {DVR.verify('api', url: '/').must_equal true}
      .must_raise(Minitest::Assertion)
    end

  end

  describe ".verify_all" do

    it "verifies all links" do
      DVR.verify_all('api', url: '/api').must_equal true
    end

    it "returns error messages when there are changes" do
      -> {DVR.verify_all('api_with_changes', url: '/api_with_changes')
            .must_equal true}
      .must_raise(Minitest::Assertion)
    end

  end

  describe ".after_test_message" do

    let(:tmp_dir) {
      File.join(
        DVR::SPEC_ROOT,
        '/../tmp/dvr_library_dir/new_dir'
      )
    }
    before {
      DVR.configure do |c|
        c.dvd_library_dir = tmp_dir
      end
    }

    after(:each)  { FileUtils.rm_rf tmp_dir }

    it "is blank if no untested files" do
      DVR.after_test_message.must_equal ''
    end

    it "exists if there are untested files" do
      File.open("#{tmp_dir}/unnecessary_dvd.json", 'w') { }
      DVR.after_test_message.must_match /unnecessary_dvd.json/
    end

  end

end
