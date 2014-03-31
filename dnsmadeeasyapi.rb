require 'yaml'
require 'time'
require 'openssl'
require 'httparty'
require 'json'

class DnsMadeEasy
  include HTTParty
  #debug_output $stderr
  disable_rails_query_string_format
  
  def initialize (api_key, api_secret, sandbox = false)
    raise "api_key is undefined" unless api_key
    raise "api_secret is undefined" unless api_secret
    
    @api_key = api_key
    @api_secret = api_secret
    
    self.class.headers request_headers
    
    if sandbox
      self.class.base_uri 'https://api.sandbox.dnsmadeeasy.com/V2.0'
    else
      self.class.base_uri 'https://api.dnsmadeeasy.com/V2.0'
    end
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
  
  # -----------------------------------
  # ------------- DOMAINS -------------
  # -----------------------------------
  
  def get_id_by_domain(domain_name)
    domain = self.class.get("/dns/managed/id/#{domain_name}")
    return domain['id']
  end

  def domains
    self.class.get('/dns/managed/')
  end

  def domain(domain_name)
    id = get_id_by_domain(domain_name)
    self.class.get("/dns/managed/#{id}")
  end
  
  def delete_domain(domain_name)
    id = get_id_by_domain(domain_name)
    self.class.delete("/dns/managed/#{id}")
  end
  
  def create_domains(names = Array())
    self.class.post('/dns/managed/', :body => { "names" => names }.to_json )
  end
  
  def create_domain(domain_name)
    self.create_domains([domain_name])
  end
  
  # -----------------------------------
  # ------------- RECORDS -------------
  # -----------------------------------

  def records_for(domain_name)
    id = get_id_by_domain(domain_name)
    self.class.get("/dns/managed/#{id}/records")
  end
  
  def delete_records(domain_name, ids = [])
    id = get_id_by_domain(domain_name)
    
    self.class.delete("/dns/managed/#{id}/records/", :body => ids.to_json)
  end
  
  def delete_record(domain_name, record_id)
    id = get_id_by_domain(domain_name)
    
    self.class.delete("/dns/managed/#{id}/records/#{record_id}/")
  end
  
  def create_record(domain_name, name, type, value, options = {})
    id = get_id_by_domain(domain_name)
    
    body = { "name" => name, "type" => type, "value" => value, "ttl" => 3600, "gtdLocation" => "DEFAULT" }
    result = body.merge(options)
    
    self.class.post("/dns/managed/#{id}/records/", :body => result.to_json )
  end
  
  def create_a_record(domain_name, name, value, options = {})
    # todo: match IPv4 for value
    self.create_record(domain_name, name, "A", value, options)
  end
  
  def create_aaaa_record(domain_name, name, value, options = {})
    # todo: match IPv6 for value
    self.create_record(domain_name, name, "AAAA", value, options)
  end
  
  def create_ptr_record(domain_name, name, value, options = {})
    # todo: match PTR value
    self.create_record(domain_name, name, "PTR", value, options)
  end
  
  def create_txt_record(domain_name, name, value, options = {})
    # todo: match TXT value
    self.create_record(domain_name, name, "TXT", value, options)
  end
  
  def create_cname_record(domain_name, name, value, options = {})
    # todo: match CNAME value
    self.create_record(domain_name, name, "CNAME", value, options)
  end
  
  def create_ns_record(domain_name, name, value, options = {})
    # todo: match domainname for value
    self.create_record(domain_name, name, "NS", value, options)
  end
  
  def create_spf_record(domain_name, name, value, options = {})
    self.create_record(domain_name, name, "SPF", value, options)
  end
  
  def create_mx_record(domain_name, name, priority, value, options = {})    
    options.merge!({ "mxLevel" => priority })
    
    self.create_record(domain_name, name, "MX", value, options)
  end

  def create_srv_record(domain_name, name, priority, weight, port, value, options = {})
    options.merge!({ "priority" => priority, "weight" => weight, "port" => port })
    
    self.create_record(domain_name, name, "SRV", value, options)
  end
  
  def create_httpred_record(domain_name, name, value, redirectType = "STANDARD - 302", description = "", keywords = "", title = "", options = {})
    options.merge!({ "redirectType" => redirectType, "description" => description, "keywords" => keywords, "title" => title })
    
    self.create_record(domain_name, name, "HTTPRED", value, options)
  end
end