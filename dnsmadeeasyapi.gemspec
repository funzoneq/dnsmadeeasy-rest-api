Gem::Specification.new do |s|
  s.name          = 'dnsmadeeasyapi'
  s.version       = '0.0.3'
  s.authors       = 'Arnoud Vermeer'
  s.email         = 'a.vermeer@freshway.biz'
  s.license       = 'GPL-2'
  s.summary       = 'DNS Made Easy V2.0 REST API client for Ruby'
  s.description   = 'DNS Made Easy V2.0 REST API client for Ruby using HTTParty'
  s.homepage      = 'https://github.com/funzoneq/dnsmadeeasyapi'

  s.files         = `git ls-files`.split("\n")

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
end
