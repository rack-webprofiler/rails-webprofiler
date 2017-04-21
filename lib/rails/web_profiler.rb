require "rack/webprofiler"

module Rails
  class WebProfiler
    autoload :VERSION,             "rails/web_profiler/version"
    autoload :NotificationHandler, "rails/web_profiler/notification_handler"

    module Collectors
      autoload :ActionViewCollector,   "rails/web_profiler/collectors/action_view_collector"
      autoload :ActiveRecordCollector, "rails/web_profiler/collectors/active_record_collector"
      autoload :RailsCollector,        "rails/web_profiler/collectors/rails_collector"
      autoload :RequestCollector,      "rails/web_profiler/collectors/request_collector"
    end
  end
end

require "rails/web_profiler/railtie" if defined? Rails
