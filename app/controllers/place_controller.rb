require 'uri'
require 'net/http'
require 'openssl'

class PlaceController < ApplicationController
  def index
    response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/cities/#{wikidataid}", :headers=>{"X-RapidAPI-Key"=>'',"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
    results=JSON.parse(response)
    puts results["data"]
=begin
    url = URI("https://wft-geo-db.p.rapidapi.com/v1/geo/cities/#{wikidataid}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = 'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226'
    request["X-RapidAPI-Host"] = 'wft-geo-db.p.rapidapi.com'

    response = http.request(request)
    puts response.read_body
=end
  end
  def translate_the_place
    url = URI("https://google-translate1.p.rapidapi.com/language/translate/v2")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["Accept-Encoding"] = 'application/json'
    request["X-RapidAPI-Key"] = ''
    request["X-RapidAPI-Host"] = 'google-translate1.p.rapidapi.com'
    request.body = "q=#{params[:name].downcase.capitalize()}&target=en"

    response = http.request(request)
    results=JSON.parse(response.read_body)
    arr=results["data"]["translations"]
    x=arr[0]
    city=x["translatedText"]
  end

  def wikidataid
    response=HTTP.get("https://en.wikipedia.org/w/api.php", :params=>{:action=>'query',:prop=>'pageprops',:titles=>translate_the_place,:format=>'json'})
    results=JSON.parse(response)
    x=results["query"]["pages"].to_s
    y=x.split("\"")
    results["query"]["pages"]["#{y[1]}"]["pageprops"]["wikibase_item"]
  end

end
