# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-foodtaster-server/version'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-foodtaster-server"
  gem.version       = Vagrant::Foodtaster::Server::VERSION
  gem.authors       = ["Mike Lapshin", "Serzh Nechyporchuk"]
  gem.email         = ["mikhail.a.lapshin@gmail.com"]
  gem.description   = %q{A Foodtaster DRb server.}
  gem.summary       = %q{Foodtaster is a tool for testing Chef cookbooks using RSpec and Vagrant. This plugin allows Foodtaster to interact with Vagrant via simple DRb protocol. }
  gem.homepage      = ""
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
