require 'time'
require 'openssl'
require 'json'
require 'uri'
require 'net/http'

# A class to interact with the DNSMadeEasy REST API v2.0
class DnsMadeEasy
  attr_accessor :base_uri

  def initialize(api_key, api_secret, sandbox = false, options = {})
    fail 'api_key is undefined' unless api_key
    fail 'api_secret is undefined' unless api_secret

    @api_key = api_key
    @api_secret = api_secret
    @options = options

    if sandbox
      self.base_uri = 'https://sandboxapi.dnsmadeeasy.com/V2.0'
    else
      self.base_uri = 'https://api.dnsmadeeasy.com/V2.0'
    end
  end

  # -----------------------------------
  # ------------- DOMAINS -------------
  # -----------------------------------

  def get_id_by_domain(domain_name)
    get("/dns/managed/id/#{domain_name}")['id']
  end

  def domains
    get '/dns/managed/'
  end

  def domain(domain_name)
    get "/dns/managed/#{get_id_by_domain(domain_name)}"
  end

  def delete_domain(domain_name)
    delete "/dns/managed/#{get_id_by_domain(domain_name)}"
  end

  def create_domains(names)
    post('/dns/managed/', names: names)
  end

  def create_domain(domain_name)
    create_domains([domain_name])
  end

  # -----------------------------------
  # ------------- RECORDS -------------
  # -----------------------------------

  def records_for(domain_name)
    get "/dns/managed/#{get_id_by_domain(domain_name)}/records"
  end

  def find(domain_name, name, type)
    records = records_for(domain_name)
    records['data'].detect { |r| r['name'] == name && r['type'] == type }
  end

  def find_record_id(domain_name, name, type)
    records = records_for(domain_name)

    records['data'].select { |r| r['name'] == name && r['type'] == type }.map { |r| r['id'] }
  end

  def delete_record(domain_name, record_id)
    delete "/dns/managed/#{get_id_by_domain(domain_name)}/records/#{record_id}/"
  end

  def delete_records(domain_name, ids = [])
    return if ids.empty?
    domain_id = get_id_by_domain(domain_name)

    delete "/dns/managed/#{domain_id}/records?ids=#{ids.join(',')}"
  end

  def delete_all_records(domain_name)
    domain_id = get_id_by_domain(domain_name)
    delete "/dns/managed/#{domain_id}/records"
  end

  def create_record(domain_name, name, type, value, options = {})
    body = { 'name' => name, 'type' => type, 'value' => value, 'ttl' => 3600, 'gtdLocation' => 'DEFAULT' }
    post "/dns/managed/#{get_id_by_domain(domain_name)}/records/", body.merge(options)
  end

  def create_a_record(domain_name, name, value, options = {})
    # TODO: match IPv4 for value
    create_record domain_name, name, 'A', value, options
  end

  def create_aaaa_record(domain_name, name, value, options = {})
    # TODO: match IPv6 for value
    create_record domain_name, name, 'AAAA', value, options
  end

  def create_ptr_record(domain_name, name, value, options = {})
    # TODO: match PTR value
    create_record domain_name, name, 'PTR', value, options
  end

  def create_txt_record(domain_name, name, value, options = {})
    # TODO: match TXT value
    create_record domain_name, name, 'TXT', value, options
  end

  def create_cname_record(domain_name, name, value, options = {})
    # TODO: match CNAME value
    create_record domain_name, name, 'CNAME', value, options
  end

  def create_ns_record(domain_name, name, value, options = {})
    # TODO: match domainname for value
    create_record domain_name, name, 'NS', value, options
  end

  def create_spf_record(domain_name, name, value, options = {})
    create_record domain_name, name, 'SPF', value, options
  end

  def create_mx_record(domain_name, name, priority, value, options = {})
    options.merge!('mxLevel' => priority)

    create_record domain_name, name, 'MX', value, options
  end

  def create_srv_record(domain_name, name, priority, weight, port, value, options = {})
    options.merge!('priority' => priority, 'weight' => weight, 'port' => port)
    create_record domain_name, name, 'SRV', value, options
  end

  def create_httpred_record(domain_name, name, value, redirectType = 'STANDARD - 302', description = '', keywords = '', title = '', options = {})
    options.merge!('redirectType' => redirectType, 'description' => description, 'keywords' => keywords, 'title' => title)
    create_record domain_name, name, 'HTTPRED', value, options
  end

  def update_record(domain, record_id, name, type, value, options = {})
    body = { 'name' => name, 'type' => type, 'value' => value, 'ttl' => 3600, 'gtdLocation' => 'DEFAULT', 'id' => record_id }
    put "/dns/managed/#{get_id_by_domain(domain)}/records/#{record_id}/", body.merge(options)
  end

  private

  def get(path)
    request(path) do |uri|
      Net::HTTP::Get.new(uri)
    end
  end

  def delete(path, body = nil)
    request(path) do |uri|
      req = Net::HTTP::Delete.new(uri)
      req.body = body.to_json if body
      req
    end
  end

  def put(path, body = nil)
    request(path) do |uri|
      req = Net::HTTP::Put.new(uri)
      req.body = body.to_json if body
      req
    end
  end

  def post(path, body)
    request(path) do |uri|
      req = Net::HTTP::Post.new(uri)
      req.body = body.to_json
      req
    end
  end

  def request(path)
    uri = URI("#{base_uri}#{path}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if @options.key?(:ssl_verify_none)
    http.open_timeout = @options[:open_timeout] if @options.key?(:open_timeout)
    http.read_timeout = @options[:read_timeout] if @options.key?(:read_timeout)

    request = yield(uri)

    request_headers.each do |key, value|
      request[key] = value
    end

    response = http.request(request)
    response.value # raise Net::HTTPServerException unless response was 2xx

    unparsed_json = response.body.to_s.empty? ? '{}' : response.body

    JSON.parse(unparsed_json)
  end

  def request_headers
    request_date = Time.now.httpdate
    hmac = OpenSSL::HMAC.hexdigest('sha1', @api_secret, request_date)
    {
      'Accept' => 'application/json',
      'x-dnsme-apiKey' => @api_key,
      'x-dnsme-requestDate' => request_date,
      'x-dnsme-hmac' => hmac
    }
  end
end
