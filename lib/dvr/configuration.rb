require 'fileutils'

module DVR
  class Configuration

    attr_reader :dvd_library_dir,
                :service_host

    def dvd_library_dir=(dir)
      FileUtils.mkdir_p(dir) if dir
      @dvd_library_dir = dir ? absolute_path_for(dir) : nil
    end

    def service_host=(url = 'localhost:9393')
      @service_host = url
    end

    private

    def absolute_path_for(path)
      Dir.chdir(path) { Dir.pwd }
    end

  end
end
