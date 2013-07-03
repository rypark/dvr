require_relative "dvr/version"

require_relative "dvr/configuration"
require_relative "dvr/dvd"

module DVR

  class << self

    # 1. See if this dvd file already exists
    #    - if it does, read the file and return its response,
    #      which will probably be a bunch of json.
    #    - if it doesn't, make the request, save the response,
    #      and return it like above
    def use_dvd(name, options = {}, &block)
      unless block
        raise ArgumentError, "`DVR.use_dvd` requires a block. " +
                             "If you cannot wrap your code in a block, use " +
                             "`DVR.insert_dvd` / `DVR.eject_dvd` instead."
      end

      dvd = insert_dvd(name, options)

      begin
        # call_block(block, dvd)
        block.call(*dvd)
      ensure
        eject_dvd
      end
    end

    def insert_dvd(name, options)
      @dvd = Dvd.new(name, options)
    end

    def eject_dvd
      @dvd.eject
    end

    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    # TODO This will be the main (and only, for now) entry point for tests.
    #      Just sketching ideas for now. Move it to some testing module later.
    def verify(dvd_name, url: nil, params: {}, &block)
      require 'uri'
      ##################
      # 1. Make request
      ##################
      uri       = URI("#{@configuration.service_host}/#{url}")
      uri.query = URI.encode_www_form(params)
      response  = Net::HTTP.get_response(uri)
      raise "Response not successful: #{response}" unless response.is_a?(Net::HTTPSuccess)

      ##################
      # 2. Save results to new DVD if it doesn't already exist
      ##################
      dvd = DVD.new(dvd_name)
      dvd.save_to_file(response.body) if dvd.new_record?

      ##################
      # 3. Pass if file structure & result matches; fail if they don't.
      ##################
      response.body === dvd.body
    end

  end

end
