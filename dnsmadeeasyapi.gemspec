Gem::Specification.new do |s|
  s.name          = 'dnsmadeeasyapi-good'
  s.version       = '1.0.1'
  s.authors       = ['Paul Henry', 'James Hart']
  s.email         = 'ops@wanelo.com'
  s.license       = 'Apache'
  s.summary       = 'DNS Made Easy V2.0 REST API client for Ruby'
  s.description   = 'DNS Made Easy V2.0 REST API client for Ruby, but better. With tests and no dependencies.'
  s.homepage      = 'https://github.com/wanelo/dnsmadeeasyapi'

  s.files         = `git ls-files`.split("\n")

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
end
