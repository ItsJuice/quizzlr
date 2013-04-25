$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "quizzlr/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "quizzlr"
  s.version     = Quizzlr::VERSION
  s.authors     = ["Liam"]
  s.email       = ["liam@itsjuice.com"]
  s.homepage    = "http://www.itsjuice.com"
  s.summary     = "A mongoid quiz engine"
  s.description = "A multiple choice quiz engine built on Mongoid including a front-end"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency 'mongoid'
  s.add_dependency 'carrierwave-mongoid'
  s.add_dependency 'rmagick' # image manipulation
  s.add_dependency 'dynamic_form'
  
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'forgery'
  s.add_development_dependency "database_cleaner"
end
