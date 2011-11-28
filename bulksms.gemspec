# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bulksms/version"

Gem::Specification.new do |s|
  s.name        = "bulksms"
  s.version     = Bulksms::VERSION
  s.authors     = ["Sam Lown", "Basayel Said", "Shuntyard Technologies"]
  s.email       = ["me@samlown.com"]
  s.homepage    = "https://github.com/samlown/bulksms"
  s.summary     = %q{Simple BulkSMS API}
  s.description = %q{Send SMS text messages via the BulkSMS API.}

  s.rubyforge_project = "bulksms"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "fakeweb"
  # s.add_runtime_dependency "rest-client"
end
