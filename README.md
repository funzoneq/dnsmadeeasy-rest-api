Dns Made Easy Api, but better.
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

Start by creating a new instance of the `DnsMadeEasy` class, and passing your api key and secret.

```ruby
api = DnsMadeEasy.new('awesome-api-key', 'super-secret-and-awesome-api-secret')
```

All return values are the direct JSON responses from DNS Made Easy converted into a Hash.

See: [http://www.dnsmadeeasy.com/wp-content/themes/appdev/pdf/API-Documentationv2.pdf](http://www.dnsmadeeasy.com/wp-content/themes/appdev/pdf/API-Documentationv2.pdf)

### Managing Domains

To retrieve all domains:

```ruby
api.domains
```

To retreive the id of a domain by the domain name:

```ruby
api.get_id_by_domain('hello.wanelo.com')
```

To retrieve the full domain record by domain name:

```ruby
api.domain('hello.wanelo.com')
```

To create a domain:

```ruby
api.create_domain('hello.wanelo.com')

# Multiple domains can be created by:

api.create_domains(['hello.wanelo.com', 'sup.wanelo.com'])
```

To delete a domain:

```ruby
api.delete_domain('hello.wanelo.com')
```

### Managing Records

To retrieve all records for a given domain name:

```ruby
api.records_for('hello.wanelo.com')
```

To find the record id for a given domain, name, and type:

This finds the id of the A record 'woah.hello.wanelo.com'.

```ruby
api.find_record_id('hello.wanelo.com', 'woah', 'A')
```

To delete a record by domain name and record id (the record id can be retrieved from `find_record_id`:

```ruby
api.delete_record('hello.wanelo.com', 123)

# To delete multiple records:

api.delete_records('hello.wanelo.com', [123, 143])
```

To create a record:

```ruby
api.create_record('hello.wanelo.com', 'woah', 'A', '127.0.0.1', { 'ttl' => '60' })

api.create_a_record('hello.wanelo.com', 'woah', '127.0.0.1', {})

api.create_aaaa_record('hello.wanelo.com', 'woah', '127.0.0.1', {})

api.create_ptr_record('hello.wanelo.com', 'woah', '127.0.0.1', {})

api.create_txt_record('hello.wanelo.com', 'woah', '127.0.0.1', {})

api.create_cname_record('hello.wanelo.com', 'woah', '127.0.0.1', {})

api.create_ns_record('hello.wanelo.com', 'woah', '127.0.0.1', {})

api.create_spf_record('hello.wanelo.com', 'woah', '127.0.0.1', {})

# Arguments are: domain_name, name, priority, value, options = {}
api.create_mx_record('hello.wanelo.com', 'woah', 5, '127.0.0.1', {})

# Arguments are: domain_name, name, priority, weight, port, value, options = {}
api.create_srv_record('hello.wanelo.com', 'woah', 1, 5, 80, '127.0.0.1', {})

# Arguments are: domain_name, name, value, redirectType, description, keywords, title, options = {}
api.create_httpred_record('hello.wanelo.com', 'woah', '127.0.0.1', 'STANDARD - 302', 'a description', 'keywords', 'a title', {})
```

To update a record:

```ruby
api.update_record('hello.wanelo.com', 123, 'woah', 'A', '127.0.1.1', { 'ttl' => '60' })
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
