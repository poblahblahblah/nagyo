# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nagyo-worker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Damian Martinez"]
  gem.email         = ["damian-gh@malachiarts.com"]
  gem.description   = %q{Nagyo worker writes nagios config from nagyo-server , nventory data.}
  gem.summary       = %q{Single script to pull nventory nodes and write out nagios config with nagyo-server data.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nagyo-worker"
  gem.require_paths = ["lib"]
  gem.version       = Nagyo::Worker::VERSION

  # requirements
  gem.add_development_dependency "rake"
  #gem.add_development_dependency "rspec"

  gem.add_runtime_dependency "nventory-client"
  gem.add_runtime_dependency "nv_helpers"
  gem.add_runtime_dependency "rest-client"
  gem.add_runtime_dependency "json"
  # nice to have but maybe not absolutely necessary ...
  gem.add_runtime_dependency "activesupport"

end
