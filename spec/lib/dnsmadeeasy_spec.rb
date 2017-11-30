require 'spec_helper'

# Verify that the backwards syntax still works
RSpec.describe DnsMadeEasy do
  let(:api_key) { 'soooo secret' }
  let(:api_secret) { 'soooo secret' }

  subject(:client) { described_class.new(api_key, api_secret) }

  context '#new' do
    it { is_expected.to be_kind_of(DnsMadeEasy::Rest::Api::Client) }
    it { is_expected.to respond_to(:get_id_by_domain) }
  end
end
