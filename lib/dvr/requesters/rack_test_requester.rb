require 'rack/test'

module DVR
  class RackTestRequester < Requester

    include Rack::Test::Methods

    def service
      DVR.configuration.rack_test_service
    end

    def app
      service.app
    end

    def get_response
      send @method, @url, @params
      @response = last_response
    end

  end
end
