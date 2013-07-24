Dir.glob(__dir__ + '/dvr/util/**/*.rb', &method(:require))

require_relative "dvr/version"

require_relative "dvr/configuration"
require_relative "dvr/comparer"
require_relative "dvr/dvd"
require_relative "dvr/requester"
require_relative "dvr/requesters/rack_test_requester"
require_relative "dvr/errors"
require_relative "dvr/core_ext/array"
require_relative "dvr/core_ext/hash"

module DVR

  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def requester_class
      @requester_class ||= (
        configuration.rack_test_service ? RackTestRequester : Requester
      )
    end

    # Verify that a current response's structure
    # matches that of the old saved response.
    # 
    # Example usage:
    # --------------------------------------------------------
    # DVR.verify(
    #   'receive_results',          #filename
    #   url: '/receive_results',    #make request to this url
    #   params: {'id' => search.id} #params for path
    # )
    # --------------------------------------------------------
    def verify(dvd_name, url: nil, params: {}, method: :get, verify_content: false)
      comparer = Comparer.new(
        dvd_name,
        url:    url,
        params: params,
        method: method,
        verify_content: verify_content
      )
      comparer.run ? true : comparer.error_message
    end

    # Similar to .verify, but will follow all links and verify them recursively.
    # Intended to be used from the root of a hypermedia service.
    def verify_all(dvd_name, url: nil, params: {}, method: :get, verify_content: nil)
      errors = []
      comparer = Comparer.new(
        dvd_name,
        url: url,
        params: params,
        method: method,
        verify_content: verify_content
      )
      unless comparer.run
        errors << comparer.error_message
      end

      if (links = comparer.response_hash['links'])
        links.each do |h|
          url    = h['href'].sub(/http:\/\/[^\/]+/, '')
          result = verify_all(h['rel'], url: url)
          errors.concat(result) unless result == true
        end
      end
      errors.none? ? true : errors
    end

    # Once the test suite is run, ensure there are no dvd files left untested.
    # Notify the user in case they've accidentally removed a form/action.
    # Will be called in the after test hook of whatever testing framework
    # is in use.
    def after_test_message
      begin
        existing_files = Dir.entries(configuration.dvd_library_dir).reject{ |e|
          e[-1] == '.'
        }
      rescue Errno::ENOENT
        return ''
      end

      untested_dvd_files = existing_files - dvd_files
      if untested_dvd_files.any?
        "\033[31m"          + # make output red
        "\n\n"              +
        "***************\n" +
        "* DVR NOTICE: *\n" +
        "***************\n" +
        "The following files were found in #{configuration.dvd_library_dir},\n" +
        "but they were not tested in any DVR tests:\n\n" +
        untested_dvd_files.join("\n") + "\n\n" +
        "Please ensure that this form/action was not accidentally removed.\n" +
        "You may have simply forgotten to write a test for it.\n" +
        "If it was removed on purpose, you may need to check for other " +
        "services that were relying on it.\n" +
        "When you're sure it's not longer needed, simply delete it." +
        "\033[0m\n"
      else
        ''
      end
    end

    def dvd_files
      @dvd_files ||= []
    end

  end

end
