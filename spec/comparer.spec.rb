require_relative 'spec_helper'

describe DVR::Comparer do

  before do
    DVR.configure do |c|
      c.service_host    = "http://localhost:#{DVR::SinatraApp.port}"
      c.dvd_library_dir = DVR::SPEC_ROOT + '/fixtures/dvds'
    end
  end

  describe '.run' do

    it 'returns true when comparison passes' do
      comparer = DVR::Comparer.new('root', url: '/')
      comparer.run.must_equal true
      DVR.dvd_files.must_include 'root.json'
    end

    it 'returns false and sets error when comparison fails' do
      comparer = DVR::Comparer.new('root', url: '/api')
      comparer.run.must_equal false
    end

    it 'adds dvd to DVR.dvd_files list' do
      comparer = DVR::Comparer.new('root', url: '/')
      comparer.run
      DVR.dvd_files.must_include 'root.json'
    end

  end

end
