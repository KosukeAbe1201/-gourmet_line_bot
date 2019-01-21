require 'rails_helper'
require 'webmock'
include WebMock::API

WebMock.allow_net_connect!

RSpec.describe Gurunavi, type: :model do
  before do
    WebMock.enable!
    WebMock.stub_request(:get, "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=12345678&latitude=35.5139807&longitude=139.6808441&range=2")
    .to_return(status: 200, body: File.read("#{Rails.root}/spec/json/stub_api_response.json", headers: { 'Content-Type' =>  'application/json' }
         )
       )
  end

  describe "api_url" do
      it "returns api url correctry" do
        ENV["GURUNAVI_KEY"] = "12345678"
        expect(
          Gurunavi::api_url(123.56, 7.89)
        ).to eq "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=12345678&latitude=123.56&longitude=7.89&range=2"
    end
  end

  describe "return_rest" do
      it "returns single restraunt correctry" do
        expect(
          (Gurunavi::return_rest("35.5139807", "139.6808441")).has_value?("テストレストラン")
        ).to be true
    end
  end
end
