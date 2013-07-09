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

    def save_to_file(response_body)
      return false if persisted?
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

    def structure_eq_to?(response_body)
      body_hash           =  JSON.parse(body)
      response_hash       =  JSON.parse(response_body)
      if body_hash.deep_keys == response_hash.deep_keys
        true
      else
        @error_message = "Expected:\n#{body_hash.deep_keys.inspect}\n" +
                         "Actual:\n#{response_hash.deep_keys.inspect}"
        false
      end
    end

  end
end
