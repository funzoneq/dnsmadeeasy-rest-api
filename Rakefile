require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby) do |t|
    t.options = ['-D']
  end
end

desc 'Run all style checks'
task style: ['style:ruby']

desc 'Run CRSpec unit tests'
RSpec::Core::RakeTask.new(:unit) do |t|
  t.rspec_opts = '--color --format documentation'
end

# The default rake task should just run it all
desc 'Run all tests'
task default: %w(style unit)
