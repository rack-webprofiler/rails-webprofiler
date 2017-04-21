# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/web_profiler/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-webprofiler"
  spec.version       = Rails::WebProfiler::VERSION
  spec.authors       = ["Nicolas Brousse"]
  spec.email         = ["pro@nicolas-brousse.fr"]

  spec.summary       = %q{A web profiler for Rails applications.}
  spec.description   = %q{A web profiler for Rails applications.}
  spec.homepage      = "http://github.com/rack-webprofiler/rails-webprofiler"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    # raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(bin|test|spec|features|examples)/}) \
    || f.match(%r{^(Guardfile|Gemfile|Rakefile)$}) \
    || f.match(%r{^(\..*)$})
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 5.0.0"
  spec.add_dependency "rack-webprofiler", "~> 0.1.3"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
