module DVR

  class HostNotFound < StandardError
    def initialize
      super "Expected service to be running on " +
            "#{DVR.configuration.service_host} but it was not found. " +
            "Please start the service and try again."
    end
  end

  class NonJsonResponse < StandardError
    def initialize
      super "Expected response to be a JSON string. " +
            "Please make sure you're using the correct route."
    end
  end

end