lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dnsmadeeasy/rest/api/version'

Gem::Specification.new do |s|
  s.name          = 'dnsmadeeasy-rest-api'
  s.version       = DnsMadeEasy::Rest::Api::VERSION
  s.authors       = ['Arnoud Vermeer', 'Paul Henry', 'James Hart', 'Konstantin Gredeskoul']
  s.email         = %w(a.vermeer@freshway.biz ops@wanelo.com kigster@gmail.com)
  s.license       = 'Apache'
  s.summary       = 'DNS Made Easy V2.0 REST API client for Ruby'
  s.description   = 'DNS Made Easy V2.0 REST API client for Ruby. With tests and no dependencies.'
  s.homepage      = 'https://github.com/funzoneq/dnsmadeeasy-rest-api'

  s.files         = `git ls-files`.split("\n")

  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rubocop'
end
