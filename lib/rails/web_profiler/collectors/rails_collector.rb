module Rails
  # @todo extends Rack::WebProfiler::Collectors::RackCollector
  class WebProfiler::Collectors::RailsCollector
    include ::Rack::WebProfiler::Collector::DSL

    icon <<-'ICON'
data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyMDAgMTk5LjgiIHdpZHRoPSIyMHB4IiBoZWlnaHQ9IjIwcHgiID4gIDxnIGZpbGw9IiM1ODU0NzMiPiAgICA8cGF0aCBkPSJNMjMuMSwxOTdoOTUuOHMtMjEuMy00OC4zLTE1LjktOTIuNiw0MC4zLTY0LjUsNjAuMi02Ni42LDMwLjYsMTAuMSwzMC42LDEwLjFsNC4zLTYuNXMtMjguNS0yOC44LTY0LjUtMjUuNi02MC45LDI3LTc2LjQsNTUuOC0yNC41LDQ5LTMwLjYsNzkuM1MyMy4xLDE5NywyMy4xLDE5N1oiLz4gICAgPHBhdGggZD0iTTQsMTQ4LjdsMTguNywxLjQtMy4yLDE4LjdMMS44LDE2Ni43WiIvPiAgICA8cGF0aCBkPSJNMzMuNSwxMDkuMWw1LTE0TDIyLDg4LjZsLTUuNCwxNS4xWiIvPiAgICA8cGF0aCBkPSJNNTcsNjAuOGw5LjctMTEuNUw1NC4xLDQxLDQ0LDUyLjJaIi8+ICAgIDxwYXRoIGQ9Ik04Mi41LDE2LjFsOC42LDEwLjQsMTEuOS02LjhMOTQuNCwxMFoiLz4gICAgPHBhdGggZD0iTTEyNC43LDQuM2wyLjIsMTAuNCwxNC44LS40TDE0MC4yLDVaIi8+ICAgIDxwYXRoIGQ9Ik0xNzQuNywxNS40bC0uNCw2LjUsMTAuMSw1LjQsMi4yLTMuMloiLz4gICAgPHBhdGggZD0iTTE3Mi42LDQzLjJ2NS40bDkuNywxLjFWNDUuM1oiLz4gICAgPHBhdGggZD0iTTE0MS42LDQ3LjhsNC43LDguNiw2LjgtNS40LTEuNC01LjhaIi8+ICAgIDxwYXRoIGQ9Ik0xMjYuOCw1OSwxMzQsNjkuOGwtNC4zLDcuNkwxMTkuMyw2NS45WiIvPiAgICA8cGF0aCBkPSJNMTEyLjQsODguOWwtNC43LDkuNEwxMjAsMTA4LjdsMi45LTExLjlaIi8+ICAgIDxwYXRoIGQ9Ik0xMDcuNCwxMjEuN2wtLjcsMTIuNiwxNS4xLDYuNS0uNy0xMS45WiIvPiAgICA8cGF0aCBkPSJNMTExLjcsMTY2LjRsMy42LDEzLDE5LjEsMS4xLTYuOC0xNFoiLz4gIDwvZz4gPC9zdmc+
ICON

    identifier "rails.rails"
    label      "Rails"
    position   1

    collect do |request|
      store :rack_version, ::Rack.release

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
    <h3>Rack informations</h3>

    <table>
      <tbody>
        <tr>
          <th>Version</th>
          <td><%=h data(:rack_version) %></td>
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
