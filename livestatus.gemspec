$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "livestatus/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "livestatus"
  s.version     = Livestatus::VERSION
  s.authors     = ["Matthew Delves"]
  s.email       = ["matt@reformedsoftware.com"]
  s.homepage    = "https://github.com/mattdelves/livestatus"
  s.summary     = "Record and track stats of your page and display in realtime"
  s.description = "Record and track stats of your page and display in realtime"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 4.0.4"
  s.add_dependency "influxdb", "~> 0.1.7"
  s.add_dependency 'sass-rails', '~> 4.0.0'
  s.add_dependency 'bootstrap-sass', '~> 3.1.1'

  # Development dependencies
  s.add_development_dependency "rspec-rails", "~> 3.0.0.beta2"
  s.add_development_dependency "rspec-mocks", "~> 3.0.0.beta2"
  s.add_development_dependency "pry"
  s.add_development_dependency "timecop"
  s.add_development_dependency 'combustion', '~> 0.5.1'
end
