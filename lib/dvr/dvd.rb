require 'json'
module DVR
  class Dvd

    include DVR::Diff

    attr_accessor :name, :error_message

    def initialize(name)
      @name = name
    end

    def persisted?
      File.exist?(file_path)
    end

    def save_to_file(response_body, force: false)
      return false if persisted? && !force
      begin
        response_json = JSON.parse(response_body)
        File.open(file_path, 'w') { |f|
          f.write JSON.pretty_generate(response_json)
        }
      rescue
        raise DVR::NonJsonResponse
      end
      true
    end

    def body
      return if !persisted?
      @body ||= JSON.parse(File.read(file_path)).to_json
    end

    def file_path
      DVR.configuration.dvd_library_dir + '/' + @name + '.json'
    end

     def compare!(response_body, verify_content: false)
      body_json = JSON.parse(body)

      if verify_content
        compare_keys_and_content(body_json, response_body)
      else
        compare_keys(body_json, response_body)
      end
    end

  private

    # If we're looking at a form, we need to ensure that everything matches;
    # not just the keys.
    def compare_keys_and_content(body_json, response_body)
      response_json = JSON.parse(response_body)
      if body_json == response_json
        true
      else
        @error_message = diff_message(body_json, response_json)
        false
      end
    end

    def compare_keys(body_json, response_body)
      response_json = JSON.parse(response_body)
      body_keys        = body_json.deep_keys
      response_keys    = response_json.deep_keys
      if body_keys.ensure_no_subtractions(response_keys)
        save_to_file(response_body, force: true) if body_keys != response_keys
        true
      else
        @error_message = diff_message(body_keys, response_keys)
        false
      end
    end

    def diff_message(expected, actual)
      ["Unexpected response for #{@name}:",
       diff(expected, actual)
      ].join("\n")
    end

  end
end
