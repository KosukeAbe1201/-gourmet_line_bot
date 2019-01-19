require 'rails_helper'
require 'line/bot'

RSpec.describe WebhookController, type: :controller do
  describe "#callback" do
    it "responds succesfully" do
      get :callback
      expect(response).to be_success
    end

    it "returns a 200 response" do
      get :callback
      expect(response).to have_http_status "200"
    end
  end
end
