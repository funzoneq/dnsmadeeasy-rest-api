
module DnsMadeEasy
  PRODUCTION_API_ENDPOINT = 'https://api.dnsmadeeasy.com/V2.0'
  SANDBOX_API_ENDPOINT    = 'https://sandboxapi.dnsmadeeasy.com/V2.0'
end

require_relative 'dnsmadeeasy/rest/api/client'

module DnsMadeEasy
  class << self
    def new(*args)
      ::DnsMadeEasy::Rest::Api::Client.new(*args)
    end
  end
end
