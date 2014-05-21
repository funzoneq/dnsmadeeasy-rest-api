require 'time'
require 'openssl'
require 'json'
require 'uri'
require 'net/http'

class Dnsmadeeasyapi

  attr_accessor :base_uri

  def initialize (api_key, api_secret, sandbox = false)
    raise "api_key is undefined" unless api_key
    raise "api_secret is undefined" unless api_secret

    @api_key = api_key
    @api_secret = api_secret

    if sandbox
      self.base_uri = 'https://api.sandbox.dnsmadeeasy.com/V2.0'
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

  def find_record_id(domain_name, name, type)
    records = records_for(domain_name)

    records['data'].select { |r| r['name'] == name && r['type'] == type }
                   .map    { |r| r['id'] }
  end

  def delete_records(domain_name, ids = [])
    id = get_id_by_domain(domain_name)

    delete "/dns/managed/#{id}/records/", ids
  end

  def delete_record(domain_name, record_id)
    delete "/dns/managed/#{get_id_by_domain(domain_name)}/records/#{record_id}/"
  end

  def create_record(domain_name, name, type, value, options = {})
    body = {"name" => name, "type" => type, "value" => value, "ttl" => 3600, "gtdLocation" => "DEFAULT"}
    post "/dns/managed/#{get_id_by_domain(domain_name)}/records/", options.merge(body)
  end

  def create_a_record(domain_name, name, value, options = {})
    # todo: match IPv4 for value
    create_record domain_name, name, "A", value, options
  end

  def create_aaaa_record(domain_name, name, value, options = {})
    # todo: match IPv6 for value
    create_record domain_name, name, "AAAA", value, options
  end

  def create_ptr_record(domain_name, name, value, options = {})
    # todo: match PTR value
    create_record domain_name, name, "PTR", value, options
  end

  def create_txt_record(domain_name, name, value, options = {})
    # todo: match TXT value
    create_record domain_name, name, "TXT", value, options
  end

  def create_cname_record(domain_name, name, value, options = {})
    # todo: match CNAME value
    create_record domain_name, name, "CNAME", value, options
  end

  def create_ns_record(domain_name, name, value, options = {})
    # todo: match domainname for value
    create_record domain_name, name, "NS", value, options
  end

  def create_spf_record(domain_name, name, value, options = {})
    create_record domain_name, name, "SPF", value, options
  end

  def create_mx_record(domain_name, name, priority, value, options = {})
    options.merge!({"mxLevel" => priority})

    create_record domain_name, name, "MX", value, options
  end

  def create_srv_record(domain_name, name, priority, weight, port, value, options = {})
    options.merge!({"priority" => priority, "weight" => weight, "port" => port})
    create_record domain_name, name, "SRV", value, options
  end

  def create_httpred_record(domain_name, name, value, redirectType = "STANDARD - 302", description = "", keywords = "", title = "", options = {})
    options.merge!({"redirectType" => redirectType, "description" => description, "keywords" => keywords, "title" => title})
    create_record domain_name, name, "HTTPRED", value, options
  end

  def update_record(domain, record_id, name, type, value, options = {})
    body = { "name" => name, "type" => type, "value" => value, "ttl" => 3600, "gtdLocation" => "DEFAULT", "id" => record_id}
    put "/dns/managed/#{get_id_by_domain(domain)}/records/#{record_id}/", options.merge(body)
  end

  private

  def get(path)
    request(path) do |uri|
      Net::HTTP::Get.new(uri.path)
    end
  end

  def delete(path, body = nil)
    request(path) do |uri|
      req = Net::HTTP::Delete.new(uri.path)
      req.body = body.to_json if body
      req
    end
  end

  def put(path, body = nil)
    request(path) do |uri|
      req = Net::HTTP::Put.new(uri.path)
      req.body = body.to_json if body
      req
    end
  end

  def post(path, body)
    request(path) do |uri|
      req = Net::HTTP::Post.new(uri.path)
      req.body = body.to_json
      req
    end
  end

  def request(path)
    uri = URI("#{base_uri}#{path}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = yield(uri)

    request_headers.each do |key, value|
      request[key] = value
    end

    response = http.request(request)

    JSON.parse(response.body)
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
