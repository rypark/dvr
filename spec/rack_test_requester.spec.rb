require_relative 'spec_helper'
require 'rack/test'

include Rack::Test::Methods

describe DVR::RackTestRequester do

  let(:tmp_dir) {
    File.join(
      DVR::SPEC_ROOT,
      '/../tmp/dvr_library_dir/new_dir'
    )
  }

  let(:dvd) { Minitest::Mock.new }

  before do
    DVR.configure do |c|
      c.dvd_library_dir   = tmp_dir
      c.rack_test_service = DVR::SinatraApp
    end
  end

  after(:each)  { FileUtils.rm_rf tmp_dir }

  it "makes request and saves to dvd" do
    expected_response = '{"animals":["cat","dog","chinchilla"]}'
    dvd.expect(:save_to_file, true, [expected_response])
    requester = DVR::RackTestRequester.make(dvd: dvd, url: '/')
    requester.response.body.must_equal expected_response
  end

  it "makes post request" do
    form_args = {
      'animal' => {'name'     => 'cat',
                   'whiskers' => 'true'}
    }
    dvd = DVR::Dvd.new('post-an-animal')
    requester = DVR::RackTestRequester.make(
      dvd: dvd,
      url: '/post-an-animal',
      method: :post,
      params: form_args)
    requester.response.body.must_equal form_args.to_json
  end

end
