require 'net/http'

module DVR
  class Requester

    attr_reader :response

    # 1. Make request
    # 2. Save response to dvd if it doesn't already exist
    def self.make(options)
      req = new(options)
      req.get_response
      req.save_response_to_dvd
      req
    end

    def initialize(options)
      @dvd    = options[:dvd]
      @url    = options[:url]    || ''
      @params = options[:params] || { }
      @method = options[:method] || :get
    end

    def get_response
      http      = Net::HTTP.new(uri.hostname, uri.port)
      request   = request_class.new(uri)
      @response = http.request(request)
    end

    def save_response_to_dvd
      @dvd.save_to_file(@response.body)
    end

    private

    def uri
      @uri ||= -> {
        path = "#{DVR.configuration.service_host}#{@url}"
        path << '?' + DVR::Util::QueryParams.encode(@params) if @params.any?
        URI(path)
      }.call
    end

    def request_class
      Kernel.const_get("Net::HTTP::#{@method.to_s.capitalize}")
    end

  end
end
