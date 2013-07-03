require_relative "dvr/version"

require_relative "dvr/configuration"
require_relative "dvr/dvd"

module DVR

  class << self

    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    # TODO This will be the main (and only, for now) entry point for tests.
    #      Just sketching ideas for now. Move it to some testing module later.
    # Example usage:
    # DVR.verify(
    #   'receive_results',          #filename
    #   url: '/receive_results',    #make request to this url
    #   params: {'id' => search.id} #params for path
    # )
    # This would magically ensure that a current response's structure
    # matches that of the old saved response.
    def verify(dvd_name, url: nil, params: {}, &block)
      require 'uri'
      ##################
      # 1. Make request
      ##################
      uri       = URI("#{@configuration.service_host}/#{url}")
      uri.query = URI.encode_www_form(params) if params.any?
      response  = Net::HTTP.get_response(uri)
      raise "Response not successful: #{response}" unless response.is_a?(Net::HTTPSuccess)

      ##################
      # 2. Save results to new DVD if it doesn't already exist
      ##################
      dvd = Dvd.new(dvd_name)
      dvd.save_to_file(response.body) if !dvd.persisted?

      ##################
      # 3. Pass if file structure & result matches; fail if they don't.
      ##################
      response.body === dvd.body
    end

  end

end
