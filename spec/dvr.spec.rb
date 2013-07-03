require_relative 'spec_helper'

describe DVR do

  describe ".use_dvd" do

    before do
      DVR.configuration.dvd_library_dir = "#{DVR::SPEC_ROOT}/fixtures/dvds"
    end

    it "saves new file if dvd doesn't exist" do
      skip
      DVR.use_dvd('i_do_not_exist') { }
    end

    it "uses existing file if dvd already exists" do
      skip
      DVR.use_dvd('example') { }
    end

  end

end
