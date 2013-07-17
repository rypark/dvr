require 'json'
module DVR
  class Dvd

    attr_accessor :name, :error_message

    def initialize(name, options = {})
      @name = name
    end

    def persisted?
      File.exist?(file_path)
    end

    def save_to_file(response_body, force: false)
      return false if persisted? && !force
      File.open(file_path, 'w') { |f|
        begin
          json_body = JSON.parse(response_body)
          f.write JSON.pretty_generate(json_body)
        rescue JSON::ParserError
          raise DVR::NonJsonResponse
        end
      }
      true
    end

    def body
      return if !persisted?
      @body ||= JSON.parse(File.read(file_path)).to_json
    end

    def file_path
      DVR.configuration.dvd_library_dir + '/' + @name + '.json'
    end

    def compare!(response_body)
      body_keys        = JSON.parse(body).deep_keys
      response_keys    = JSON.parse(response_body).deep_keys
      if body_keys.ensure_no_subtractions(response_keys)
        save_to_file(response_body, force: true) if body_keys != response_keys
        true
      else
        @error_message = "Unexpected response for #{@name}:\n" +
                         "Expected:\n-#{body_keys.inspect}\n" +
                         "Actual:\n+#{response_keys.inspect}"
        false
      end
    end

  end
end
