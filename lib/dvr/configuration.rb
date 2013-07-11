require 'fileutils'

# TODO maybe an :api_key option that would automatically append it
#      to all requests. To avoid pesky NotAuthorized errors.
#      If so, remember to take Requester#uri into account, otherwise
#      we'll end up with a url with two '?'s in it.
#      (just do path << DVR.configuration.api_key if there is one)
module DVR
  class Configuration

    attr_reader :dvd_library_dir,
                :service_host

    def dvd_library_dir=(dir)
      FileUtils.mkdir_p(dir) if dir
      @dvd_library_dir = dir ? absolute_path_for(dir) : nil
    end

    def service_host=(url = 'http://localhost:9393')
      @service_host = url
    end

    private

    def absolute_path_for(path)
      Dir.chdir(path) { Dir.pwd }
    end

  end
end
