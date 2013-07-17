require 'rspec/expectations'

module DVR
  module RSpecHelpers

    # A shortcut so we don't have to type DVR.verify() for every test.
    def verify_dvr(filename, options = {})
      expect(DVR.verify(filename, options)).to be_a_valid_response
    end

    def verify_all_dvr(filename, options = {})
      expect(DVR.verify_all(filename, options)).to be_a_valid_response
    end

    RSpec::Matchers.define :be_a_valid_response do
      match do |result|
        result == true
      end

      failure_message_for_should do |result|
        result.join("\n--------------------------\n")
      end

      failure_message_for_should_not do |result|
        "Expected response to be invalid but it was, in fact, quite valid."
      end

    end

  end
end
