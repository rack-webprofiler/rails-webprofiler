module Rails
  class WebProfiler::Collectors::ActionViewCollector
    include ::Rack::WebProfiler::Collector::DSL

    icon <<-'ICON'
data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9IjIwcHgiIHZpZXdCb3g9IjAgMCAxMjAgMTIwIiB3aWR0aD0iMjBweCIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+ICA8cGF0aCBkPSJNNTYuNywyMS4ySDEyLjh2MTA3LjJoNzcuOFY1NS4xaC0zNFYyMS4yTDU2LjcsMjEuMnogTTY0LjgsMjEuMlY0N2gyNS45TDY0LjgsMjEuMkw2NC44LDIxLjJ6IiBmaWxsPSIjNTg1NDczIi8+PC9zdmc+
ICON

    identifier "rails.action_view"
    label      "ActionView"
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
    <h3>ActionView</h3>

    <% unless data(:events).empty? %>
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
    <% else %>
    <p><span class="text__no-value">No views loaded.</span></p>
    <% end %>
  </div>
<% end %>
