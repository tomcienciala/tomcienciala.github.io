# -*- encoding: utf-8 -*-
# stub: parslet 1.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "parslet".freeze
  s.version = "1.5.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kaspar Schiess".freeze]
  s.date = "2012-12-27"
  s.email = "kaspar.schiess@absurd.li".freeze
  s.extra_rdoc_files = ["README".freeze]
  s.files = ["README".freeze]
  s.homepage = "http://kschiess.github.com/parslet".freeze
  s.rdoc_options = ["--main".freeze, "README".freeze]
  s.rubygems_version = "3.5.9".freeze
  s.summary = "Parser construction library with great error reporting in Ruby.".freeze

  s.installed_by_version = "3.5.9".freeze if s.respond_to? :installed_by_version

  s.specification_version = 3

  s.add_runtime_dependency(%q<blankslate>.freeze, ["~> 2.0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<flexmock>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rdoc>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<sdoc>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<guard>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<guard-rspec>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rb-fsevent>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<growl>.freeze, [">= 0".freeze])
end
