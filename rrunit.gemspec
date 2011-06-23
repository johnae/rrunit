# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rrunit/version"

Gem::Specification.new do |s|
  s.name        = "rrunit"
  s.version     = Rrunit::VERSION
  s.authors     = ["John Axel Eriksson"]
  s.email       = ["john@insane.se"]
  s.homepage    = "https://github.com/johnae/rrunit"
  s.summary     = %q{Creates and writes runit service files}
  s.description = %q{Creates and writes runit service files}

  s.rubyforge_project = "rrunit"

  s.add_development_dependency "bundler", ">= 1.0.10"
  s.add_development_dependency('rspec', '>= 2.6.0')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
