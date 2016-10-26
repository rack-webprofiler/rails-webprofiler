class Rails::WebProfiler::NotificationHandler
  def call(*args)
    event = ActiveSupport::Notifications::Event.new(*args)

    events = ::Rack::WebProfiler.data("rails.events")
    events ||= Events.new
    events << event
    ::Rack::WebProfiler.data("rails.events", events)
  end

  class Events < Array
    def by_event_name(event_name)
      select do |e|
        if event_name.is_a?(Array)
          event_name.include?(e.name)
        else
          e.name === event_name
        end
      end
    end

    alias by_event_names by_event_name
  end
end
