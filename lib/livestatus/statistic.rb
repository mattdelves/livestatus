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
                  :params,
                  :key

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
      @key    = "#{@controller}_#{@action}".gsub("::", '_').downcase
      @key    = "#{@key}_#{status}" if @status
      @influxdb = ::InfluxDB::Client.new "livestatus", host: "localhost"
    end

    def data
      {
       controller: @controller,
       action: @action,
       view_runtime: @view_runtime,
       db_runtime: @db_runtime,
       format: @format,
       method: @method,
       path: @path,
       params: @params
      }
    end

    def to_json
      self.data.to_json
    end

    def save
      @influxdb.write_point(@key, self.data)
    end

    def self.save_notification notification
      statistic = self.new notification
      statistic.save
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
      results = influxdb.query(query)
      results.keys.sort
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
