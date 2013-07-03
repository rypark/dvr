require_relative '../spec_helper'

describe "Making request to test sinatra app" do

  let(:tmp_dir) {
    File.join(
      DVR::SPEC_ROOT,
      '/../tmp/dvr_library_dir/new_dir'
    )
  }
  before {
    DVR.configure do |c|
      c.service_host    = "http://localhost:#{DVR::SinatraApp.port}"
      c.dvd_library_dir = tmp_dir
    end
  }

  after(:each)  { FileUtils.rm_rf tmp_dir }

  it "saves dvd file" do
    DVR.verify 'root', url: '', params: {}
    File.exist?("#{tmp_dir}/root.json").must_equal true
  end

end
