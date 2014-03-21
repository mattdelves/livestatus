$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "livestatus/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "livestatus"
  s.version     = Livestatus::VERSION
  s.authors     = ["Matthew Delves"]
  s.email       = ["matt@reformedsoftware.com"]
  s.homepage    = "github.com/mattdelves/livestatus"
  s.summary     = "Record and track stats of your page and display in realtime"
  s.description = "Record and track stats of your page and display in realtime"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.4"
end
