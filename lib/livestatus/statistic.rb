require 'redis'

module Livestatus
  class Statistic

    REDIS = ::Redis.new

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

    def save
      key = "#{@controller}_#{@action}_#{@status}"
      REDIS.rpush "#{key}", "#{self.to_json}"
    end

    def self.save_notification notification
      statistic = self.new notification
      statistic.save
      statistic
    end

    def self.recent controller, action, status
      key = "#{controller}_#{action}_#{status}"
      length = REDIS.llen "#{controller}_#{action}_#{status}"
      start = length - 100
      start = 0 if start < 0
      REDIS.lrange key, start, length
    end

  end
end
