module Rails
  # @todo extends Rack::WebProfiler::Collectors::RackCollector
  class WebProfiler::Collectors::RailsCollector
    include ::Rack::WebProfiler::Collector::DSL

    icon nil

    collector_name "rails"
    position       1

    collect do |request, _response|
      store :rails_version, Rails.version
      store :rails_env,     Rails.env
      store :rails_doc_url, "http://api.rubyonrails.org/v#{Rails.version}/"
      store :env,           hash_stringify_values(request.env)
    end

    template __FILE__, type: :DATA

    is_enabled? -> { defined? ::Rails }

    class << self
      def hash_stringify_values(hash)
        return {} unless hash.kind_of?(Hash)
        hash.collect do |k,v|
          v = v.inspect unless v.kind_of?(String)
          [k, v]
        end
      end
    end
  end
end

__END__
<% tab_content do %>
  <%=h data(:rails_version) %> | <%=h data(:rails_env) %>
<% end %>

<% panel_content do %>
  <div class="block">
    <h3>Rails informations</h3>

    <table>
      <tbody>
        <tr>
          <th>Version</th>
          <td><%=h data(:rails_version) %></td>
        </tr>
        <tr>
          <th>Environment</th>
          <td><%=h data(:rails_env) %></td>
        </tr>
        <tr>
          <th>Documentation</th>
          <td><a href="<%=h data(:rails_doc_url) %>"><%=h data(:rails_doc_url) %></td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="block">
    <h3>Env</h3>

    <% if data(:env) && !data(:env).empty? %>
    <table>
      <thead>
        <tr>
          <th>Key</th>
          <th>Value</th>
        </tr>
      <thead>
      <tbody>
      <% data(:env).sort.each do |k, v| %>
        <tr>
          <th><%=h k %></th>
          <td class="code"><%=h v %></td>
        </tr>
      <% end %>
      </tbody>
    </table>
    <% else %>
    <p><span class="text__no-value">No rack env datas</span></p>
    <% end %>
  </div>
<% end %>
