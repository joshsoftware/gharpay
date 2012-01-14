# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gharpay/version"

Gem::Specification.new do |s|
  s.name        = "gharpay"
  s.version     = Gharpay::VERSION
  s.authors     = ["Jeyant"]
  s.email       = ["jeyant@joshsoftware.com"]
  s.homepage    = ""
  s.summary     = %q{Gharpay API integration}
  s.description = %q{Gharpay Cash on Delivery API integration}

  s.rubyforge_project = "gharpay"

  s.add_dependency(%q<httparty>, ["~> 0.4.3"])

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
