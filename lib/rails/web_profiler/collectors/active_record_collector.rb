module Rails
  class WebProfiler::Collectors::ActiveRecordCollector
    include ::Rack::WebProfiler::Collector::DSL

    icon <<-'ICON'
data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PHN2ZyB3aWR0aD0iMjBweCIgaGVpZ2h0PSIyMHB4IiB2aWV3Qm94PSIwIDAgMjAgMjAiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+ICAgICAgICA8dGl0bGU+UmVjdGFuZ2xlIDQ8L3RpdGxlPiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4gICAgPGRlZnM+PC9kZWZzPiAgICA8ZyBpZD0iUGFnZS0xIiBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIj4gICAgICAgIDxnIGlkPSJEZXNrdG9wLTIiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0xMS4wMDAwMDAsIC0yNTAuMDAwMDAwKSIgZmlsbD0iIzU4NTQ3MyI+ICAgICAgICAgICAgPGcgaWQ9IkRhdGFiYXNlIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwLjAwMDAwMCwgMjQwLjAwMDAwMCkiPiAgICAgICAgICAgICAgICA8cGF0aCBkPSJNMTEsMTAgTDMxLDEwIEwzMSwxNiBMMTEsMTYgTDExLDEwIFogTTExLDE3IEwzMSwxNyBMMzEsMjMgTDExLDIzIEwxMSwxNyBaIE0xMSwyNCBMMzEsMjQgTDMxLDMwIEwxMSwzMCBMMTEsMjQgWiIgaWQ9IlJlY3RhbmdsZS00Ij48L3BhdGg+ICAgICAgICAgICAgPC9nPiAgICAgICAgPC9nPiAgICA8L2c+PC9zdmc+
ICON

    identifier "rails.active_record"
    label      "ActiveRecord"
    position   10

    collect do
      data = ::Rack::WebProfiler.data("rails.events")

      events = []
      events = data.by_event_name("sql.active_record") unless data.nil?

      ar_conn = ActiveRecord::Base.connection
      store :connection, {
        adapter_class: ar_conn.class.name,
        adapter_name:  ar_conn.adapter_name,
      }

      total_duration = events.inject(0) { |sum, e| sum + e.duration }

      store :events,         events
      store :total_duration, total_duration
    end

    template __FILE__, type: :DATA

    is_enabled? -> { defined? ::ActiveRecord }
  end
end

__END__
<% tab_content do %>
  <%=h data(:events).length %>

  <div class="details">
    <div class="wrapper">
      <dl>
        <dt>Total</dt>
        <dd><%=h data(:events).length %></dd>
      </dl>
    </div>
  </div>
<% end %>

<% panel_content do %>
  <div class="block">
    <h3>Informations</h3>

    <p>Queries: <%=h data(:events).length %></p>
    <p>Total time: <%=h data(:total_duration).round(2) %> ms</p>
  </div>

  <div class="block">
    <h3>SQL Queries</h3>

    <% unless data(:events).empty? %>
    <table>
      <thead>
        <tr>
          <th width="140">#</th>
          <th>SQL</th>
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
            <%=highlight language: :sql, code: e.payload[:sql] %>
          <% if e.payload[:binds].length > 0 %>
            <strong>params: </strong> <code>[<%=h e.payload[:binds].map { |b| "[\"#{b.name}\", #{b.value_for_database.inspect}]" }.join(", ") %>]</code>
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
    <p><span class="text__no-value">No queries executed.</span></p>
    <% end %>
  </div>

  <div class="block">
    <h3>Connection</h3>

    <% conn = data(:connection) %>
    <table>
      <tbody>
        <tr>
          <th>Adapter class</th>
          <td><code><%=h conn[:adapter_class] %></code></td>
        </tr>
        <tr>
          <th>Adapter name</th>
          <td><%=h conn[:adapter_name] %></td>
        </tr>
      </tbody>
    </table>
  </div>
<% end %>
