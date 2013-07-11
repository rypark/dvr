module DVR
  module Minitest::Assertions

    def assert_dvr_response(dvd_name, url: nil, params: {}, method: :get)
      result  = DVR.verify(dvd_name, url: url, params: params, method: method)
      result == true ? pass : flunk(result)
    end

  end
end
