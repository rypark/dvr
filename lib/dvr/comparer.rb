module DVR
  class Comparer

    extend Forwardable
    def_delegator :@dvd, :error_message

    attr_reader :dvd,
                :url,
                :params,
                :method,
                :verify_content,
                :response

    def initialize(dvd_name, url: nil, params: {}, method: :get, verify_content: nil)
      @dvd            = DVR::Dvd.new(dvd_name)
      @url            = url
      @params         = params
      @method         = method
      @verify_content = verify_content
      @requester      = DVR.requester_class
    end

    def run
      @response = @requester.make(
        dvd:    dvd,
        url:    url,
        params: params,
        method: method
      ).response

      DVR.dvd_files << "#{dvd.name}.json"
      @verify_content = !!response_hash['form'] if @verify_content.nil?

      dvd.compare!(response.body, verify_content: @verify_content)
    end

    def response_hash
      @response_hash ||= JSON.parse(response.body)
    end

  end
end
