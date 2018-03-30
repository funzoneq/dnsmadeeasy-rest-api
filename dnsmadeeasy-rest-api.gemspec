Gem::Specification.new do |s|
  s.name          = 'dnsmadeeasy-rest-api'
  s.version       = '1.0.8'
  s.authors       = ['Arnoud Vermeer', 'Paul Henry', 'James Hart']
  s.email         = ['a.vermeer@freshway.biz', 'ops@wanelo.com']
  s.license       = 'Apache'
  s.summary       = 'DNS Made Easy V2.0 REST API client for Ruby'
  s.description   = 'DNS Made Easy V2.0 REST API client for Ruby. With tests and no dependencies.'
  s.homepage      = 'https://github.com/funzoneq/dnsmadeeasy-rest-api'

  s.files         = `git ls-files`.split("\n")

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rubocop'
end
