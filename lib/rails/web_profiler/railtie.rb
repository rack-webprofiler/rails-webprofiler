require "rails"

module Rails
  # WebProfiler::Railtie
  class WebProfiler::Railtie < ::Rails::Railtie # :nodoc:
    initializer "rails-webprofiler.configure_rails_initialization" do |app|
      app.middleware.use ::Rack::WebProfiler do |c|
        c.tmp_dir = ::File.expand_path(::File.join(Rails.root, "tmp"), __FILE__)
      end

      ::Rack::WebProfiler.unregister_collector [
        # ::Rack::WebProfiler::Collectors::ExceptionCollector,
        ::Rack::WebProfiler::Collectors::RackCollector,
        ::Rack::WebProfiler::Collectors::RequestCollector,
      ]

      ::Rack::WebProfiler.register_collector [
        Rails::WebProfiler::Collectors::ActionViewCollector,
        Rails::WebProfiler::Collectors::ActiveRecordCollector,
        Rails::WebProfiler::Collectors::RailsCollector,
        Rails::WebProfiler::Collectors::RequestCollector,
      ]

      # Subscrine all Rails notifications.
      handler = Rails::WebProfiler::NotificationHandler.new
      ActiveSupport::Notifications.subscribe(/.+/, handler)
    end
  end
end
