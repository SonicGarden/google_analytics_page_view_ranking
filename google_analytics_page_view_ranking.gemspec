# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_analytics_page_view_ranking/version'

Gem::Specification.new do |spec|
  spec.name          = "google_analytics_page_view_ranking"
  spec.version       = GoogleAnalyticsPageViewRanking::VERSION
  spec.authors       = ["Akihiro MATSUMURA"]
  spec.email         = ["matsumura.aki@gmail.com"]

  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'oauth2'
  spec.add_dependency 'garb'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
