require 'sinatra'

module DVR
  class SinatraApp < ::Sinatra::Base
    disable :protection

    # TODO JSON responses!
    get '/' do
      "GET to root"
    end

    get '/search' do
      "query: #{params[:q]}"
    end

    get '/localhost_test' do
      "Localhost response"
    end

    get '/foo' do
      "FOO!"
    end

    post '/foo' do
      "FOO!"
    end

    get '/set-cookie-headers/1' do
      headers 'Set-Cookie' => 'foo'
      'header set'
    end

    get '/set-cookie-headers/2' do
      headers 'Set-Cookie' => %w[ bar foo ]
      'header set'
    end

    get '/204' do
      status 204
    end

    @_boot_failed = false

    class << self
      def port
        server.port
      end

      def server
        raise "Sinatra app failed to boot." if @_boot_failed
        @server ||= begin
          DVR::LocalhostServer.new(new)
        rescue
          @_boot_failed = true
          raise
        end
      end

      alias boot server
    end
  end
end
