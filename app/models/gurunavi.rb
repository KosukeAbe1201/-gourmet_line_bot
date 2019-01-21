class Gurunavi < ActiveRecord::Base
BASE_API_URL = "https://api.gnavi.co.jp/RestSearchAPI/v3/".freeze
SEARCH_RANGE = 2

  def self.api_url(lat, lon)
    hash = {
      "keyid" =>      ENV["GURUNAVI_KEY"],
      "latitude" =>      lat,
      "longitude" =>      lon,
      "range" =>      SEARCH_RANGE,
      "hit_per_page" => 50
    }
    BASE_API_URL + "?" + hash.map{|k,v| URI.encode(k.to_s) + "=" + URI.encode(v.to_s)}.join("&")
  end

  def self.return_rest(lat, lon)
    uri = URI.parse(Gurunavi::api_url(lat, lon))
    json = Net::HTTP.get(uri)
    results = JSON.parse(json)
    max_num_of_rests = results["hit_per_page"].to_i - 1
    results["rest"][Random.rand(0 .. max_num_of_rests)]
  end
end
