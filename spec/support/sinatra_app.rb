require 'sinatra'
require 'sinatra/json'
require 'multi_json'

module DVR
  class SinatraApp < ::Sinatra::Base
    helpers Sinatra::JSON
    disable :protection

    get '/' do
      json({'animals' => ['cat', 'dog', 'chinchilla']})
    end

    get '/start-search' do
      json({
        'form' => {
          'action' => '/start-search',
          'method' => 'POST',
          'fields' => [
            {
              'name'     => 'departure_time',
              'type'     => 'datetime',
              'label'    => 'Departure Time',
              'required' => 'true'
            }
          ]
        }
      })
    end

    post '/post-an-animal' do
      json({
        'animal' => params['animal']
      })
    end

    get '/api' do
      json({
        'links' => [
          {'rel'  => 'form_1',
           'href' => link_to('/api/form_1')}
        ]
      })
    end

    get '/api/form_1' do
      json({
        'required' => %w[id name]
      })
    end

    get '/api_with_changes' do
      json({
        'links' => [
          {'rel'  => 'changed_form',
           'href' => link_to('/api/form_1')}
        ]
      })
    end

    get '/204' do
      status 204
    end

    def link_to(str)
      "#{request.scheme}://#{request.host}:#{SinatraApp.port}#{str}"
    end

    @_boot_failed = false

    class << self

      def app
        self
      end

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
