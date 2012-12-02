# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nagyo-server-helper/version"

Gem::Specification.new do |s|
  s.name        = "nagyo-server-helper"
  s.version     = Nagyo::Server::Helper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors   = ["Pat O'Brien"]
  s.email     = ["pobrien@eharmony.com"]
  s.homepage    = "https://github.com/poblahblahblah/nagyo/nagyo-server-helper"
  s.summary     = %q{ServerHelper is a client library for Nagyo Server}
  s.description = %q{Nagyo ServerHelper provides an abstraction over the Nagyo REST api}

  s.rubyforge_project = "nagyo-server-helper"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"

  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "activesupport"

  #s.add_runtime_dependency "configuration"
end
