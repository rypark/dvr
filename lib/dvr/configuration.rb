require 'fileutils'

module DVR
  class Configuration

    attr_reader   :dvd_library_dir
    attr_accessor :rack_test_service,
                  :service_host

    def dvd_library_dir=(dir)
      FileUtils.mkdir_p(dir) if dir
      @dvd_library_dir = dir ? absolute_path_for(dir) : nil
    end

    private

    def absolute_path_for(path)
      Dir.chdir(path) { Dir.pwd }
    end

  end
end
