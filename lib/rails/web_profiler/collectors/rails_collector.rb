module Rails
  class WebProfiler::Collectors::RailsCollector
    include ::Rack::WebProfiler::Collector::DSL

    icon nil

    collector_name "rails"
    position       1

    collect do |_request, _response|
      store :rails_version, Rails.version
      store :rails_env,     Rails.env
      store :rails_doc_url, "http://api.rubyonrails.org/v#{Rails.version}/"
      # Rails config
    end

    template __FILE__, type: :DATA

    is_enabled? -> { defined? ::Rails }
  end
end

__END__
<% tab_content do %>
  <%=h data(:rails_version) %> | <%=h data(:rails_env) %>
<% end %>

<% panel_content do %>
  <div class="block">

  </div>
<% end %>
