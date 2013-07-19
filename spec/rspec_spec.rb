# NOTE: While the rest of DVR tests with Minitest, this file uses RSpec to
#       test our custom matchers.
#       Note that the file extension is _spec.rb rather than .spec.rb
#       This is how RSpec picks up on what files to run.
#
###############################################################################
# This is mostly the same as spec_helper, minus the required minitest files.
ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
require_relative '../lib/dvr'
require_relative 'support/sinatra_app'
require_relative 'support/dvr_localhost_server'

module DVR; SPEC_ROOT= File.dirname(__FILE__); end
DVR::SinatraApp.boot
###############################################################################

require 'rspec'
require_relative '../lib/dvr/rspec'

include DVR::RSpecHelpers

describe DVR::RSpecHelpers do

  before do
    DVR.configure do |c|
      c.service_host    = "http://localhost:#{DVR::SinatraApp.port}"
      c.dvd_library_dir = DVR::SPEC_ROOT + '/fixtures/dvds'
    end
  end

  describe '#assert_dvr_response' do

    it "correctly asserts when response unchanged" do
      verify_dvr 'root', url: '/'
    end

    it "returns error message when response not right" do
      msg = <<-END
Unexpected response for root:
--- expected
+++ actual
@@ -1,3 +1,16 @@
 [
-  "animals"
+  {
+    "form": [
+      "action",
+      "method",
+      {
+        "fields": [
+          "name",
+          "type",
+          "label",
+          "required"
+        ]
+      }
+    ]
+  }
 ]
      END
      expect{verify_dvr('root', url: '/start-search')}
      .to raise_error(RSpec::Expectations::ExpectationNotMetError, msg)
    end

  end

  describe '#assert_all_dvr_response' do

    it 'correctly asserts when response unchanged' do
      verify_all_dvr 'api', url: '/api'
    end

    it "returns error message when response not right" do
      msg = <<-END
Unexpected response for changed_form:
--- expected
+++ actual
@@ -1,3 +1,3 @@
 [
-  "i_am_different"
+  "required"
 ]
      END

      expect{ verify_all_dvr 'api_with_changes', url: '/api_with_changes'}
      .to raise_error(RSpec::Expectations::ExpectationNotMetError, msg)
    end

  end

end
