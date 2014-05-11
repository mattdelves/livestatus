module Livestatus
  class Statistic

    attr_accessor :timestamp,
                  :controller,
                  :action,
                  :view_runtime,
                  :db_runtime,
                  :format,
                  :method,
                  :path,
                  :status,
                  :params

    def initialize options
      @timestamp = Time.now
      @controller = options[:controller]
      @action = options[:action]
      @view_runtime = options[:view_runtime]
      @db_runtime = options[:db_runtime]
      @format = options[:format]
      @method = options[:method]
      @path   = options[:path]
      @status = options[:status]
      @params = options[:params]
      @influxdb = ::InfluxDB::Client.new "livestatus", host: "localhost"
    end

    def to_json
      {
       controller: @controller,
       timestring: @timestamp.utc,
       timestamp: @timestamp.utc.to_i,
       action: @action,
       view_runtime: @view_runtime,
       db_runtime: @db_runtime,
       format: @format,
       method: @method,
       path: @path,
       params: @params
      }.to_json
    end

    def save(key, data)
      @influxdb.write_point(key, data)
    end

    def save_view_runtime
      key = key_from_components(@controller, @action, @status.to_s, "view_runtime")
      data = {
        value: @view_runtime,
        time: @timestamp.utc.to_i
      }
      self.save(key, data)
    end

    def save_db_runtime
      key = key_from_components(@controller, @action, "", "db_runtime")
      data = {
        value: @db_runtime,
        time: @timestamp.utc.to_i
      }
      self.save(key, data)
    end

    def self.save_notification notification
      statistic = self.new notification
      statistic.save_view_runtime if statistic.view_runtime.to_i > 0
      statistic.save_db_runtime if statistic.db_runtime.to_i > 0
      statistic
    end

    def self.recent(key, starttime = 1.hour.ago, endtime = Time.now.utc, limit = 100)
      influxdb = ::InfluxDB::Client.new "livestatus", host: "localhost"
      query = "select * from #{key} where time > #{starttime.to_i}s and time < #{endtime.to_i}s limit #{limit}"
      results = influxdb.query(query)
      results[key]
    end

    def self.series
      influxdb = ::InfluxDB::Client.new "livestatus", host: "localhost"
      query = "list series"
      influxdb.query(query)
    end

    def key_from_components(controller, action, status, type)
      key = "#{controller}_#{action}"
      unless status.empty?
        key = "#{key}_#{status}"
      end
      key = "#{key}_#{type}"
      key.gsub('::', '_').downcase
    end

  end
end
