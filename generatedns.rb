require './dnsmadeeasyapi.rb'
require 'pp'

config = YAML.load_file File.expand_path 'config.yml'
domain = "blabla.nl"
ptrdomain = "22.21.10.in-addr.arpa"

begin
  api = DnsMadeEasy.new(config['api_key'], config['secret_key'], config['sandbox'])
  
  pp api.create_domain(domain)
  pp api.create_domains(["test.nl", "bla.com"])
  
  pp api.create_a_record(domain, "ns0", "123.123.123.123")
  pp api.create_aaaa_record(domain, "ipv6", "2001:db8::1")
  pp api.create_ns_record(domain, "#{domain}", "ns0.#{domain}")
  pp api.create_cname_record(domain, "link", "ns0.#{domain}", { "ttl" => 3600 })
  pp api.create_txt_record(domain, "", "v=spf1 include:spf.#{domain} ?all", { "ttl" => 86400 } )
  pp api.create_spf_record(domain, "", "v=spf1 include:spf.#{domain} ?all", { "ttl" => 86400 } )
  
  # domain, name, priority, weight, port, value
  pp api.create_srv_record(domain, "_sip._tcp.#{domain}", 10, 5, 5060, "sipserver.#{domain}", { "ttl" => 86400 })
  pp api.create_srv_record(domain, "_sip._tcp.#{domain}", 10, 10, 5060, "large_sipserver.#{domain}", { "ttl" => 86400 })
  pp api.create_srv_record(domain, "_sip._tcp.#{domain}", 20, 5, 5060, "backup.#{domain}", { "ttl" => 86400 })
  
  pp api.create_httpred_record(domain, "redirect", "http://www.#{domain}/", "STANDARD - 302", "Super awesome redirect description", "super, awesome, redirect, keywords", "A redirect title")
  
  pp api.create_domain(ptrdomain)
  pp api.create_ptr_record(ptrdomain, "10", "some.host.#{domain}")
  pp api.create_ptr_record(ptrdomain, "11", "other.host.#{domain}")
  
  pp api.domains()
  
  records = api.records_for(domain)
  pp api.delete_record(domain, records['data'].first['id'])
  
  pp api.delete_domain("test.nl")
rescue Exception => e
  pp e
end