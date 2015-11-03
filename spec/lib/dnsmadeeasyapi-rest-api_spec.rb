require 'spec_helper'
require_relative '../../lib/dnsmadeeasy-rest-api'

describe DnsMadeEasy do
  let(:api_key) { 'soooo secret' }
  let(:secret_key) { 'soooo secret' }
  let(:request_headers) do
    {'Accept' => 'application/json',
      'X-Dnsme-Apikey' => 'soooo secret',
      'X-Dnsme-Hmac' => 'ff6e87e78ff909573362c9a38df13ccc5fa01846',
      'X-Dnsme-Requestdate' => 'Wed, 21 May 2014 18:08:37 GMT'}
  end

  subject { DnsMadeEasy.new(api_key, secret_key) }

  before do
    Time.stub(:now).and_return(Time.parse('Wed, 21 May 2014 18:08:37 GMT'))
  end

  describe '#get_id_by_domain' do

    let(:response) do
      "{\"name\":\"something.wanelo.com\",\"id\":1130967}"
    end

    it 'returns the id of the domain' do
      stub_request(:get, "https://api.dnsmadeeasy.com/V2.0/dns/managed/id/something.wanelo.com").
        with(:headers => request_headers).
        to_return(:status => 200, :body => response, :headers => {})

      expect(subject.get_id_by_domain('something.wanelo.com')).to eq(1130967)
    end
  end

  describe '#domains' do
    let(:response) { "{}" }

    it 'returns all the domains' do
      stub_request(:get, "https://api.dnsmadeeasy.com/V2.0/dns/managed/").
        with(:headers => request_headers).
        to_return(:status => 200, :body => response, :headers => {})

      expect(subject.domains).to eq({})
    end
  end

  describe "#domain" do
    let(:response) { "{}" }

    before do
      subject.stub(:get_id_by_domain).with('something.wanelo.com').and_return(123)
    end

    it "returns the domain given a domain name" do
      stub_request(:get, "https://api.dnsmadeeasy.com/V2.0/dns/managed/123").
        with(:headers => request_headers).
        to_return(:status => 200, :body => response, :headers => {})

      expect(subject.domain('something.wanelo.com')).to eq({})
    end
  end

  describe '#delete_domain' do
    let(:response) { "{}" }

    before do
      subject.stub(:get_id_by_domain).with('something.wanelo.com').and_return(123)
    end

    it 'deletes the domain' do
      stub_request(:delete, "https://api.dnsmadeeasy.com/V2.0/dns/managed/123").
        with(:headers => request_headers).
        to_return(:status => 200, :body => response, :headers => {})

      expect(subject.delete_domain('something.wanelo.com')).to eq({})
    end
  end

  describe '#create_domains' do
    let(:response) { "{}" }

    it 'creates the domains' do
      stub_request(:post, "https://api.dnsmadeeasy.com/V2.0/dns/managed/").
        with(:headers => request_headers, :body => '{"names":["something.wanelo.com"]}').
        to_return(:status => 200, :body => response, :headers => {})

      expect(subject.create_domains(['something.wanelo.com'])).to eq({})
    end
  end

  describe '#create_domain' do
    it 'calls create_domains with the one domain' do
      expect(subject).to receive(:create_domains).with(['something.wanelo.com'])
      subject.create_domain('something.wanelo.com')
    end
  end

  describe '#records_for' do
    let(:response) { "{}" }

    before do
      subject.stub(:get_id_by_domain).with('something.wanelo.com').and_return(123)
    end

    it 'returns all records for a given domain' do
      stub_request(:get, "https://api.dnsmadeeasy.com/V2.0/dns/managed/123/records").
        with(:headers => request_headers).
        to_return(:status => 200, :body => response, :headers => {})

      expect(subject.records_for('something.wanelo.com')).to eq({})
    end
  end

  describe '#find' do
    let(:records_for_response) do
      {
        'data' => [
          { 'name' => 'demo', 'type' => 'A', 'id' => 123},
          { 'name' => 'demo', 'type' => 'A', 'id' => 143}
        ]
      }
    end

    before do
      subject.stub(:records_for).with('something.wanelo.com').and_return(records_for_response)
    end

    it 'finds the first record that matches name and type' do
      expect(subject.find('something.wanelo.com', 'demo', 'A')).to eq({ 'name' => 'demo', 'type' => 'A', 'id' => 123})
    end
  end

  describe '#find_record_id' do
    let(:records_for_response) do
      {
        'data' => [
          { 'name' => 'demo', 'type' => 'A', 'id' => 123},
          { 'name' => 'demo', 'type' => 'A', 'id' => 143}
        ]
      }
    end

    before do
      subject.stub(:records_for).with('something.wanelo.com').and_return(records_for_response)
    end

    it 'finds the specified record given a name and a type' do
      expect(subject.find_record_id('something.wanelo.com', 'demo', 'A')).to eq([123, 143])
    end
  end

  describe '#delete_records' do
    let(:response) { "{}" }
    let(:domain) { 'something.wanelo.com' }
    let(:domain_id) { 123 }

    context 'with an array of record ids' do
      let(:ids) { [147, 159] }

      before do
        subject.stub(:get_id_by_domain).with(domain).and_return(domain_id)

        stub_request(:delete, "https://api.dnsmadeeasy.com/V2.0/dns/managed/#{domain_id}/records?ids=#{ids.join(',')}").
          with(headers: request_headers).
          to_return(:status => 200, :body => response, :headers => {})
      end

      it 'deletes a list of records from a given domain' do
        expect(subject.delete_records('something.wanelo.com', ids)).to eq({})
      end
    end

    context 'with an empty array' do
      it 'returns early without deleting anything' do
        expect(subject.delete_records('something.wanelo.com', [])).to eq(nil)
      end
    end
  end

  describe '#delete_all_records' do
    let(:response) { "{}" }
    let(:domain) { 'something.wanelo.com' }
    let(:domain_id) { 123 }

    before do
      subject.stub(:get_id_by_domain).with(domain).and_return(domain_id)

      stub_request(:delete, "https://api.dnsmadeeasy.com/V2.0/dns/managed/#{domain_id}/records").
        with(headers: request_headers).
        to_return(:status => 200, :body => response, :headers => {})
    end

    it 'deletes all records from the domain' do
      expect(subject.delete_all_records('something.wanelo.com')).to eq({})
    end
  end

  describe '#delete_record' do
    let(:response) { "{}" }

    before do
      subject.stub(:get_id_by_domain).with('something.wanelo.com').and_return(123)
    end

    it 'deletes a record' do
      stub_request(:delete, "https://api.dnsmadeeasy.com/V2.0/dns/managed/123/records/42/").
        with(headers: request_headers).
        to_return(:status => 200, :body => response, :headers => {})

      expect(subject.delete_record('something.wanelo.com', 42)).to eq({})
    end
  end

  describe '#create_record' do
    let(:response) { "{}" }

    before do
      subject.stub(:get_id_by_domain).with('something.wanelo.com').and_return(123)
    end

    let(:domain_name) { 'something.wanelo.com' }
    let(:name) { 'test' }

    it 'creates a record' do
      stub_request(:post, "https://api.dnsmadeeasy.com/V2.0/dns/managed/123/records/").
        with(headers: request_headers, body: {"name" => 'test', "type" => 'A', "value" => '192.168.1.1', "ttl" => 3600, "gtdLocation" => "DEFAULT"}.to_json).
        to_return(:status => 200, :body => response, :headers => {})


      expect(subject.create_record(domain_name, 'test', 'A', '192.168.1.1')).to eq({})
    end
  end

  ["a", "aaaa", "ptr", "txt", "cname", "ns", "spf"].each do |record_type|
    method_name = "create_#{record_type}_record"
    describe "##{method_name}" do
      upper_record_type = record_type.upcase

      it "calls through to create record with \"#{upper_record_type}\"" do
        expect(subject).to receive(:create_record).with('something.wanelo.com', 'smellyface',  upper_record_type, '192.168.1.1', {}).and_return({})
        expect(subject.send(method_name, 'something.wanelo.com', 'smellyface', '192.168.1.1')).to eq({})
      end
    end
  end

  describe "#create_mx_record" do
    it 'creates an mx record' do
      expect(subject).to receive(:create_record).with('something.wanelo.com', 'mail', 'MX', '192.168.1.1', {'mxLevel' => 50}).and_return({})
      expect(subject.create_mx_record('something.wanelo.com', 'mail', 50, '192.168.1.1')).to eq({})
    end
  end

  describe "#create_srv_record" do
    let(:weight) { '50' }
    let(:priority) { '42' }
    let(:port) { '4040' }

    it 'creates an srv record' do
      expect(subject).to receive(:create_record).with('something.wanelo.com', 'serv', 'SRV', '192.168.1.1', {"priority" => priority, "weight" => weight, "port" => port}).and_return({})

      expect(subject.create_srv_record('something.wanelo.com', 'serv', priority, weight, port, '192.168.1.1')).to eq({})
    end
  end

  describe "#create_httpred_record" do
    let(:description) { 'hunky dory redirect description' }
    let(:keywords) { 'omg,keywords,redirect' }
    let(:redirect_type) { 'STANDARD - 302' }
    let(:title) { 'wat' }

    it 'creates an srv record' do
      expect(subject).to receive(:create_record).with('something.wanelo.com', 'redirect', 'HTTPRED', '192.168.1.1', {"redirectType" => redirect_type, "description" => description, "keywords" => keywords, "title" => title}).and_return({})

      expect(subject.create_httpred_record('something.wanelo.com', 'redirect', '192.168.1.1', redirect_type, description, keywords, title)).to eq({})
    end
  end

  describe "#update_record" do
    let(:response) { "{}" }

    before do
      subject.stub(:get_id_by_domain).with('something.wanelo.com').and_return(123)
    end

    it 'updates a record' do
      body = '{"name":"mail","type":"A","value":"1.1.1.1","ttl":3600,"gtdLocation":"DEFAULT","id":21}'


      stub_request(:put, "https://api.dnsmadeeasy.com/V2.0/dns/managed/123/records/21/").
        with(headers: request_headers, body: body).
        to_return(:status => 200, :body => response, :headers => {})


      expect(subject.update_record('something.wanelo.com', 21, 'mail', 'A', '1.1.1.1', {})).to eq({})
    end
  end

  describe "#request" do
    before do
      stub_request(:get, "https://api.dnsmadeeasy.com/V2.0/some_path").
        with(headers: request_headers).
        to_return(status: status, body: body, headers: {})
    end

    let(:response) do
      subject.send(:request, "/some_path") { |uri|
        Net::HTTP::Get.new(uri.path)
      }
    end

    context "with a 2xx, empty-string response" do
      let(:status) { 200 }
      let(:body) { "" }

      it "handles gracefully" do
        expect(response).to eq({})
      end
    end

    context "with a non-2xx response" do
      let(:status) { 400 }
      let(:body) { "<xml> JSON.parse won't like this very much </xml>" }

      it "raises a Net::HTTPServerException instead of a JSON::ParserError" do
        expect { response }.to raise_exception(Net::HTTPServerException)
      end
    end
  end
end
