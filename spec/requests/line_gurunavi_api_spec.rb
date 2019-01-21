require 'rails_helper'
require 'line/bot'
require 'webmock'
include WebMock::API

WebMock.allow_net_connect!

RSpec.describe "LineGurunaviApi", type: :request do
  before(:each) do
    WebMock.enable!
    allow_any_instance_of(Line::Bot::Client).to receive(:validate_signature).and_return(true)
    WebMock.stub_request(:post, Addressable::Template.new("#{Line::Bot::API::DEFAULT_ENDPOINT}/message/reply"))
    .to_return { |request| {body: request.body, status: 200} }
    WebMock.stub_request(:get, "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=12345678&latitude=35.5139807&longitude=139.6808441&range=2")
    .to_return(status: 200, body: File.read("#{Rails.root}/spec/json/stub_api_response.json", headers: { 'Content-Type' =>  'application/json' })
      )
  end

  describe "POST callback_path with location" do
    it "returns a 200 response" do
      post callback_path, params: File.read("#{Rails.root}/spec/json/location_content.json", headers: { 'Content-Type' =>  'application/json' })
      expect(response).to have_http_status "200"
    end
  end

  describe "POST callback_path with text" do
    it "returns a 200 response" do
      post callback_path, params: File.read("#{Rails.root}/spec/json/text_content.json", headers: { 'Content-Type' =>  'application/json' })
      expect(response).to have_http_status "200"
    end
  end
end
