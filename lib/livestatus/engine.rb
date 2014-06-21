module Livestatus
  class Engine < ::Rails::Engine
    isolate_namespace Livestatus

    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w{ rickshaw.js d3.v2.js }
      Rails.application.config.assets.precompile += %w{ rickshaw.css }

    end
  end
end
