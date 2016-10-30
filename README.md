Dns Made Easy Rest Api
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

See: [http://www.dnsmadeeasy.com/integration/pdf/API-Docv2.pdf](http://www.dnsmadeeasy.com/integration/pdf/API-Docv2.pdf)

### Managing Domains

To retrieve all domains:

```ruby
api.domains
```

To retreive the id of a domain by the domain name:

```ruby
api.get_id_by_domain('hello.example.com')
```

To retrieve the full domain record by domain name:

```ruby
api.domain('hello.example.com')
```

To create a domain:

```ruby
api.create_domain('hello.example.com')

# Multiple domains can be created by:

api.create_domains(['hello.example.com', 'sup.example.com'])
```

To delete a domain:

```ruby
api.delete_domain('hello.example.com')
```

### Managing Records

To retrieve all records for a given domain name:

```ruby
api.records_for('hello.example.com')
```

To find the record id for a given domain, name, and type:

This finds the id of the A record 'woah.hello.example.com'.

```ruby
api.find_record_id('hello.example.com', 'woah', 'A')
```

To delete a record by domain name and record id (the record id can be retrieved from `find_record_id`:

```ruby
api.delete_record('hello.example.com', 123)

# To delete multiple records:

api.delete_records('hello.example.com', [123, 143])

# To delete all records in the domain:

api.delete_all_records('hello.example.com')
```

To create a record:

```ruby
api.create_record('hello.example.com', 'woah', 'A', '127.0.0.1', { 'ttl' => '60' })

api.create_a_record('hello.example.com', 'woah', '127.0.0.1', {})

api.create_aaaa_record('hello.example.com', 'woah', '127.0.0.1', {})

api.create_ptr_record('hello.example.com', 'woah', '127.0.0.1', {})

api.create_txt_record('hello.example.com', 'woah', '127.0.0.1', {})

api.create_cname_record('hello.example.com', 'woah', '127.0.0.1', {})

api.create_ns_record('hello.example.com', 'woah', '127.0.0.1', {})

api.create_spf_record('hello.example.com', 'woah', '127.0.0.1', {})

# Arguments are: domain_name, name, priority, value, options = {}
api.create_mx_record('hello.example.com', 'woah', 5, '127.0.0.1', {})

# Arguments are: domain_name, name, priority, weight, port, value, options = {}
api.create_srv_record('hello.example.com', 'woah', 1, 5, 80, '127.0.0.1', {})

# Arguments are: domain_name, name, value, redirectType, description, keywords, title, options = {}
api.create_httpred_record('hello.example.com', 'woah', '127.0.0.1', 'STANDARD - 302', 'a description', 'keywords', 'a title', {})
```

To update a record:

```ruby
api.update_record('hello.example.com', 123, 'woah', 'A', '127.0.1.1', { 'ttl' => '60' })
```

To get the number of API requests remaining after a call:

```ruby
api.requests_remaining
```
>Information is not available until an API call has been made


To get the API request total limit after a call:
```ruby
api.request_limit
```
>Information is not available until an API call has been made


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
