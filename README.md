[![Build Status](https://travis-ci.org/kigster/dnsmadeeasy-rest-api.svg?branch=master)](https://travis-ci.org/kigster/dnsmadeeasy-rest-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/f2e66c122253167681a2/maintainability)](https://codeclimate.com/github/kigster/dnsmadeeasy-rest-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f2e66c122253167681a2/test_coverage)](https://codeclimate.com/github/kigster/dnsmadeeasy-rest-api/test_coverage)

Dns Made Easy Rest API (V2.0)
==============

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dnsmadeeasy-rest-api'
```

And then execute:

```
$ bundle
```

Or install it yourself:

```
$ gem install dnsmadeeasy-rest-api
```

## Usage

Start by creating a new instance of the `DnsMadeEasy::Rest::Api::Client` class, 
and passing your api key and secret.

```ruby
require 'dnsmadeeasy/rest/api/client'
@api = ::DnsMadeEasy::Rest::Api::Client.new('API Key', 'API Secret')  
```

#### Deprecated Usage

This usage also works, but as it conflicts with the Gem Naming guidelines it 
is discouraged.

```ruby
require 'dnsmadeeasy-rest-api'
@api = ::DnsMadeEasy.new('API Key', 'API Secret')
```

All return values are the direct JSON responses from DNS Made Easy converted into a Hash.

For more information on the actual JSON API, please refer to the [following PDF document](http://www.dnsmadeeasy.com/integration/pdf/API-Docv2.pdf).

### Managing Domains

To retrieve all domains:

```ruby
@api.domains
```

To retreive the id of a domain by the domain name:

```ruby
@api.get_id_by_domain('test.io')
```

To retrieve the full domain record by domain name:

```ruby
@api.domain('test.io')
```

To create a domain:

```ruby
@api.create_domain('test.io')

# Multiple domains can be created by:
@api.create_domains(%w[test.io moo.re])
```

To delete a domain:

```ruby
@api.delete_domain        ('test.io')
```

### Managing Records

To retrieve all records for a given domain name:

```ruby
@api.records_for          ('test.io')
```

To find the record id for a given domain, name, and type:

This finds the id of the A record 'woah.test.io'.

```ruby
@api.find_record_id       ('test.io', 'woah', 'A')
```

To delete a record by domain name and record id (the record id can be retrieved from `find_record_id`:

```ruby
@api.delete_record        ('test.io', 123)

# To delete multiple records:

@api.delete_records       ('test.io', [123, 143])

# To delete all records in the domain:

@api.delete_all_records   ('test.io')
```

To create a record:

```ruby
@api.create_record        ('test.io', 'woah', 'A', '127.0.0.1', { 'ttl' => '60' })
@api.create_a_record      ('test.io', 'woah', '127.0.0.1', {})
@api.create_aaaa_record   ('test.io', 'woah', '127.0.0.1', {})
@api.create_ptr_record    ('test.io', 'woah', '127.0.0.1', {})
@api.create_txt_record    ('test.io', 'woah', '127.0.0.1', {})
@api.create_cname_record  ('test.io', 'woah', '127.0.0.1', {})
@api.create_ns_record     ('test.io', 'woah', '127.0.0.1', {})
@api.create_spf_record    ('test.io', 'woah', '127.0.0.1', {})
# Arguments are: domain_name, name, priority, value, options = {}
@api.create_mx_record     ('test.io', 'woah', 5, '127.0.0.1', {})
# Arguments are: domain_name, name, priority, weight, port, value, options = {}
@api.create_srv_record    ('test.io', 'woah', 1, 5, 80, '127.0.0.1', {})
# Arguments are: domain_name, name, value, redirectType, description, keywords, title, options = {}
@api.create_httpred_record('test.io', 'woah', '127.0.0.1', 'STANDARD - 302', 'a description', 'keywords', 'a title', {})
```

To update a record:

```ruby
@api.update_record        ('test.io', 123, 'woah', 'A', '127.0.1.1', { 'ttl' => '60' })
```

To update several records:

```ruby
@api.update_records('test.io', 
  [
    {'id'=>123, 
      'name'=>'buddy', 
      'type'=>'A',
      'value'=>'127.0.0.1'
    }
  ], { 'ttl' => '60' })
  
```

To get the number of API requests remaining after a call:

```ruby
@api.requests_remaining
```
>Information is not available until an API call has been made


To get the API request total limit after a call:
```ruby
@api.request_limit
```
>Information is not available until an API call has been made

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
