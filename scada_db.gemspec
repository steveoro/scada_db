$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "scada_db/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "scada_db"
  s.version     = ScadaDb::VERSION
  s.authors     = ["steveoro"]
  s.email       = ["steve.alloro@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ScadaDb."
  s.description = "TODO: Description of ScadaDb."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "devise"

  s.add_development_dependency "mysql2"

  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-shell"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "ffaker"
  s.add_development_dependency 'factory_girl_rails'
end
