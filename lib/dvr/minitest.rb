module DVR
  module Minitest::Assertions

    def assert_dvr_response(dvd_name, options = {})
      result  = DVR.verify(dvd_name, options)
      result == true ? pass : flunk(result)
    end

    def assert_all_dvr_response(dvd_name, options = {})
      result = DVR.verify_all(dvd_name, options)
      result == true ? pass : flunk(result.join("\n--------------------------\n"))
    end

    alias_method :verify_dvr, :assert_dvr_response
    alias_method :verify_all_dvr, :assert_all_dvr_response

    Minitest.after_run {
      puts DVR.after_test_message
    }

  end
end
