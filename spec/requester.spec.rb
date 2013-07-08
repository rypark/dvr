require_relative 'spec_helper'

describe DVR::Requester do

  let(:tmp_dir) {
    File.join(
      DVR::SPEC_ROOT,
      '/../tmp/dvr_library_dir/new_dir'
    )
  }

  let(:dvd) { Minitest::Mock.new }

  before do
    DVR.configure do |c|
      c.service_host    = "http://localhost:#{DVR::SinatraApp.port}"
      c.dvd_library_dir = tmp_dir
    end
  end

  after(:each)  { FileUtils.rm_rf tmp_dir }

  it "makes request and saves to dvd" do
    expected_response = '{"animals":["cat","dog","chinchilla"]}'
    dvd.expect(:save_to_file, true, [expected_response])
    requester = DVR::Requester.make(dvd: dvd, url: '/')
    requester.response.body.must_equal expected_response
  end

end
