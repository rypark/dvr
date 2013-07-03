require_relative 'spec_helper'

describe DVR::Configuration do

  describe '#dvd_library_dir=' do

    let(:tmp_dir) {
      File.join(
        DVR::SPEC_ROOT,
        '/../tmp/dvr_library_dir/new_dir'
      )
    }
    let(:config)  { DVR::Configuration.new  }
    after(:each)  { FileUtils.rm_rf tmp_dir }

    it "creates the library if it doesn't exist" do
      File.exist?(tmp_dir).must_equal false
      config.dvd_library_dir = tmp_dir
      File.exist?(tmp_dir).must_equal true
    end

    it "resolves the directory to its absolute path" do
      relative_dir = 'tmp/dvr_library_dir/new_dir'
      config.dvd_library_dir = relative_dir
      absolute_dir = File.join(DVR::SPEC_ROOT.sub(/\/spec\z/, ''),
                               relative_dir)
      config.dvd_library_dir.must_equal absolute_dir
    end

  end

end
