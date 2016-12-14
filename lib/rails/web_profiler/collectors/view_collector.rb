module Rails
  class WebProfiler::Collectors::ViewCollector
    include ::Rack::WebProfiler::Collector::DSL

    icon nil

    identifier "rails.view"
    label      "View"
    position   9

    collect do |_request, _response|
      data = ::Rack::WebProfiler.data("rails.events")

      events = []
      events = data.by_event_names(%w(render_template.action_view render_partial.action_view)) unless data.nil?

      store :root_path, Rails.root.to_s
      store :events,    events
    end

    template __FILE__, type: :DATA

    is_enabled? -> { defined? ::ActiveRecord }
  end
end

__END__
<% tab_content do %>
  <%=h data(:events).length %>
<% end %>

<% panel_content do %>
  <div class="block">
  <h3>Views</h3>

  <table>
    <thead>
      <tr>
        <th width="140">#</th>
        <th>View</th>
        <th width="50">Time</th>
      </tr>
    </thead>
    <tbody>
    <% data(:events).each do |e| %>
      <tr<% if e.duration > 500 %> class="warning"<% end %>>
        <td class="code">
          <%=h e.transaction_id %>
        </td>
        <td>
          <code><%=h e.payload[:identifier].sub!(data(:root_path), '') %></code>
        <% unless e.payload[:layout].nil? %>
          within <code><%=h e.payload[:layout] %></code>
        <% end %>
        </td>
        <td>
          <%=h e.duration.round(2) %> ms
        </td>
      </tr>
    <% end %>
    </tbody>
  </table>
  </div>
<% end %>
