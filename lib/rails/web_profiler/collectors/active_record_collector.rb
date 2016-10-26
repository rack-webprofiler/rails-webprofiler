module Rails
  class WebProfiler::Collectors::ActiveRecordCollector
    include ::Rack::WebProfiler::Collector::DSL

    icon nil

    collector_name "rails_activerecord"
    position       10

    collect do |_request, _response|
      data = ::Rack::WebProfiler.data("rails.events")

      events = []
      events = data.by_event_name("sql.active_record") unless data.nil?

      store :nb_sql_requests, events.length
      store :sql_requests, events
    end

    template __FILE__, type: :DATA

    is_enabled? -> { defined? ::ActiveRecord }
  end
end

__END__
<% tab_content do %>
  <%=h data(:nb_sql_requests) %>
<% end %>

<% panel_content do %>
  <div class="block">
    <h3>SQL Queries</h3>

    <table>
      <tbody>
      <% data(:sql_requests).each do |request| %>
        <tr>
          <td>
            <pre>
            <%=highlight language: :sql, code: request.payload[:sql] %>
            in <%=h request.duration %> ms
          </td>
        </tr>
      <% end %>
      </tbody>
    </table>
  </div>
<% end %>
