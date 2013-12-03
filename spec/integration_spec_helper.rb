require File.join(File.dirname(__FILE__), 'spec_helper')

require "capybara"
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

RSpec.configure do |c|
  c.include Capybara::DSL
end

Capybara.configure do |config|
  config.match = :one
  config.exact_options = true
  config.ignore_hidden_elements = true
  config.visible_text_only = true
end

Capybara.app = app

# Useful, thanks https://coderwall.com/p/aklybw
def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    loop do
      active = page.evaluate_script('jQuery.active')
      break if active == 0
    end
  end
end
