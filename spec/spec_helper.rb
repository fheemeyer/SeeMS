require "rspec"
require "rack/test"
require "capybara"
require File.join(File.dirname(__FILE__), '..', 'app')

set :environment, :test

RSpec.configure do |conf|
  color_enabled = true
  conf.include Rack::Test::Methods
end

# Useful methods
def app
  Sinatra::Application
end
