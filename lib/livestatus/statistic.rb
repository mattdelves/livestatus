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
      REDIS.rpush "#{@controller}_#{@action}_#{@status}", "#{@timestamp.to_i}:#{self.to_json}"
    end

    def self.save_notification notification
      statistic = self.new notification
      statistic.save
      statistic
    end

    def self.recent controller, action, status
      REDIS.lrange "#{controller}_#{action}_#{status}", 0, 100
    end

  end
end
