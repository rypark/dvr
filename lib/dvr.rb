require_relative "dvr/version"

require_relative "dvr/configuration"
require_relative "dvr/dvd"
require_relative "dvr/requester"
require_relative "dvr/requesters/rack_test_requester"
require_relative "dvr/errors"
require_relative "dvr/core_ext/array"
require_relative "dvr/core_ext/hash"
require_relative "dvr/util/query_params"

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
        configuration.requester_class || Requester
      )
    end

    # Verify that a current response's structure
    # matches that of the old saved response.
    # Example usage:
    # DVR.verify(
    #   'receive_results',          #filename
    #   url: '/receive_results',    #make request to this url
    #   params: {'id' => search.id} #params for path)
    def verify(dvd_name, url: nil, params: {}, method: :get)
      dvd      = Dvd.new(dvd_name)
      request  = requester_class.make(dvd: dvd, url: url, params: params, method: method)
      response = request.response
      dvd.compare!(response.body) ? true : dvd.error_message
    end

  end

end
