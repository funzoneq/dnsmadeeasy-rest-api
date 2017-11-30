require 'simplecov'
require 'webmock/rspec'
require 'rspec'
require 'rspec/its'

SimpleCov.start

require 'dnsmadeeasy-rest-api'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
