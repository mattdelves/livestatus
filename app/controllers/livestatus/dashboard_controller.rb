require_dependency "livestatus/application_controller"
require 'livestatus/reloader/sse'

module Livestatus
  class DashboardController < ApplicationController
    include ActionController::Live

    def index
      # Write some stuff to the output stream
    end

    def stream
      # SSE expects the `text/event-stream` content type
      response.headers['Content-Type'] = 'text/event-stream'

      sse = ::Livestatus::Reloader::SSE.new(response.stream)

      begin
        loop do
          stats = Statistic.recent "DashboardController", "home", 200
          sse.write({ stats: stats }, event: "update" )
          sleep 1
        end
      rescue IOError
        # When the client disconnects, we'll get an IOError on write
      ensure
        sse.close
      end
    end
  end
end
