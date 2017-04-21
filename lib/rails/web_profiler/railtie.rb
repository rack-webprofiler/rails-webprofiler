module Rails
  class WebProfiler
    def self.initialize!(app)
      raise "Rails::WebProfiler initialized twice. Set `require: false' for rails-webprofiler in your Gemfile" if @already_initialized

      app.middleware.insert(0, ::Rack::WebProfiler)

      ::Rack::WebProfiler.reset_collectors!

      ::Rack::WebProfiler.register_collectors [
        ::Rack::WebProfiler::Collectors::RubyCollector,
        ::Rack::WebProfiler::Collectors::TimeCollector,
        Rails::WebProfiler::Collectors::ActionViewCollector,
        Rails::WebProfiler::Collectors::ActiveRecordCollector,
        Rails::WebProfiler::Collectors::RailsCollector,
        Rails::WebProfiler::Collectors::RequestCollector,
      ]

      # Subscrine all Rails notifications.
      handler = Rails::WebProfiler::NotificationHandler.new
      ActiveSupport::Notifications.subscribe(/.+/, handler)

      c = ::Rack::WebProfiler.config

      c.tmp_dir = ::File.expand_path(::File.join(Rails.root, "tmp"), __FILE__)

      @already_initialized = true
    end

    class Railtie < ::Rails::Railtie # :nodoc:
      initializer "rails-webprofiler.configure_rails_initialization" do |app|
        Rails::WebProfiler.initialize!(app)
      end
    end
  end
end
