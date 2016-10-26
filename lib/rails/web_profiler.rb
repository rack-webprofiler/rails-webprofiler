require "rack/webprofiler"

class Rails::WebProfiler

  autoload :VERSION, "rails/web_profiler/version"
  autoload :NotificationHandler, "rails/web_profiler/notification_handler"

  module Collectors
    autoload :ActiveRecordCollector, "rails/web_profiler/collectors/active_record_collector"
    autoload :RailsCollector, "rails/web_profiler/collectors/rails_collector"
    autoload :RequestCollector, "rails/web_profiler/collectors/request_collector"
    autoload :ViewCollector, "rails/web_profiler/collectors/view_collector"
  end

  module AutoConfigure
    autoload :Rails, "rails/web_profiler/auto_configure/rails"
  end
end

require "rails/web_profiler/auto_configure/rails" if defined? Rails
