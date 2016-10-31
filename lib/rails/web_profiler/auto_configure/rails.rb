require "rails"

module Rails
  # AutoConfigure::Rails
  class WebProfiler::AutoConfigure::Rails
    class Engine < ::Rails::Engine # :nodoc:
      initializer "rails-web-profiler.configure_rails_initialization" do |app|
        app.middleware.use ::Rack::WebProfiler do |c|
          c.tmp_dir = ::File.expand_path(::File.join(Rails.root, "tmp"), __FILE__)
        end

        ::Rack::WebProfiler.unregister_collector [
          ::Rack::WebProfiler::Collectors::RackCollector,
          ::Rack::WebProfiler::Collectors::RequestCollector,
        ]

        ::Rack::WebProfiler.register_collector [
          Rails::WebProfiler::Collectors::ActiveRecordCollector,
          Rails::WebProfiler::Collectors::RailsCollector,
          Rails::WebProfiler::Collectors::RequestCollector,
          Rails::WebProfiler::Collectors::ViewCollector,
        ]


        handler = Rails::WebProfiler::NotificationHandler.new
        ActiveSupport::Notifications.subscribe(/.+/, handler)
      end
    end
  end
end
