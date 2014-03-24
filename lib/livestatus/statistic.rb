module Livestatus
  class Statistic

    attr_accessor :timestamp,
                  :controller,
                  :view,
                  :view_runtime,
                  :db_runtime,
                  :format,
                  :method,
                  :path,
                  :params

    def initialize options
      @timestamp = Time.now
      @controller = options[:controller]
      @view = options[:view]
      @view_runtime = options[:view_runtime]
      @db_runtime = options[:db_runtime]
      @format = options[:format]
      @method = options[:method]
      @path   = options[:path]
      @params = options[:params]
    end



  end
end
