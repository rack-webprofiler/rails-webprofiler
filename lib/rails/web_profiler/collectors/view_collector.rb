module Rails
  class WebProfiler::Collectors::ViewCollector
    include ::Rack::WebProfiler::Collector::DSL

    icon nil

    collector_name "rails_view"
    position       9

    collect do |_request, _response|
      data = ::Rack::WebProfiler.data("rails.events")

      events = []
      events = data.by_event_names(%w(render_template.action_view render_partial.action_view)) unless data.nil?

      store :nb_events, events.length
      store :events, events
    end

    template __FILE__, type: :DATA

    is_enabled? -> { defined? ::ActiveRecord }
  end
end

__END__
<% tab_content do %>
  <%=h data(:nb_events) %>
<% end %>

<% panel_content do %>
  <div class="block">
  <h3>Views</h3>

  <table>
    <tbody>
    <% data(:events).each do |e| %>
      <tr>
        <td>
          <code><%= e.payload[:identifier] %></code> within <code><%= e.payload[:layout] %></code>
        </td>
      </tr>
    <% end %>
    </tbody>
  </table>
  </div>
<% end %>
