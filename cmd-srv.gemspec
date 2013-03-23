# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cmd-srv/version'

Gem::Specification.new do |gem|
  gem.name          = "cmd-srv"
  gem.version       = Cmd::Srv::VERSION
  gem.authors       = ["Diego Salazar"]
  gem.email         = ["diego@greyrobot.com"]
  gem.description   = %q{Serve html files in working dir}
  gem.summary       = %q{Serve html files in working dir}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'mimemagic'
end
