require_dependency "livestatus/application_controller"
require 'livestatus/reloader/sse'

module Livestatus
  class DashboardController < ApplicationController
    include ActionController::Live

    def index
      @series = Statistic.series
    end

    def stream
      # SSE expects the `text/event-stream` content type
      response.headers['Content-Type'] = 'text/event-stream'

      sse = ::Livestatus::Reloader::SSE.new(response.stream)

      begin
        loop do
          keys = Statistic.series
          stats = []
          keys.each do |key|
            values = Statistic.recent(key)
            next unless values && values.count > 0
            action_type = "view load time"
            action_type = "db load time" if values[0]["db_runtime"] && values[0]["db_runtime"].to_f > 0
            stats << {
              key: key,
              values: values,
              controller: values[0]["controller"],
              action: values[0]["action"],
              type: action_type
            }
          end
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
