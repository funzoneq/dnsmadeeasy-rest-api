require 'webmock/rspec'

RSpec.configure do |config|

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  if config.files_to_run.one?
    config.full_backtrace = true
    config.formatter = 'doc' if config.formatters.none?
  end

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
