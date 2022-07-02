require 'uri'
require 'net/http'
require 'openssl'

class PlaceController < ApplicationController
  def index
    #trova le info sul posto
    response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/cities/#{wikidataid}", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
    results=JSON.parse(response)
    if results.keys[0]=="errors" #non è una città
      response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/countries/#{wikidataid}", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
      results=JSON.parse(response)
      if results.keys[0]=="errors" #non è una nazione
        @errorinfo="Non è stato possibile trovare informazioni su #{params[:name].downcase.capitalize()}"
      else
        #se è una nazione
        @type="Nazione"
        @capital=results["data"]["capital"]
        @numregions=results["data"]["numRegions"]
      end
    else
      #se è una città
      @type="Città"
      @country=results["data"]["country"]
      @region=results["data"]["region"]
      @elevationmeters=results["data"]["elevationMeters"]
      @population=results["data"]["population"]
      @latitude=results["data"]["latitude"]
      @longitude=results["data"]["longitude"]
    end

    #trova gli hotel
    response=HTTP.get("https://booking-com.p.rapidapi.com/v1/hotels/search", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'booking-com.p.rapidapi.com'}, :params=>{:dest_id=>"#{destid}", :dest_type=>"city", :locale=>"en-us",:checkout_date=>"#{params[:checkoutdate]}", :checkin_date=>"#{params[:checkindate]}", :units=>"metric",:adults_number=>"#{params[:numpersone]}", :order_by=>"price", :filter_by_currency=>"EUR", :room_number=>"1"})
    results=JSON.parse(response)
    @hotels=results["result"]
  end

  def wikidataid #DA TOGLIERE ALLA FINE
    place=params[:name].downcase.capitalize()
    if place.include? "%20"
      arr=place.split("%20")
      place=""
      arr.each do |name|
        place=place+name+" "
      end
    end
    response=HTTP.get("https://en.wikipedia.org/w/api.php", :params=>{:action=>'query',:prop=>'pageprops',:titles=>place,:format=>'json'})
    results=JSON.parse(response)
    x=results["query"]["pages"].to_s
    y=x.split("\"")
    results["query"]["pages"]["#{y[1]}"]["pageprops"]["wikibase_item"]
  end

=begin VERSIONE ORIGINALE
  def translate_the_place
    place=params[:name].downcase.capitalize()
    if place.include? "%20"
      arr=place.split("%20")
      place=""
      arr.each do |name|
        place=place+name+" "
      end
    end

    url = URI("https://deep-translate1.p.rapidapi.com/language/translate/v2")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request["X-RapidAPI-Key"] = 'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226'
    request["X-RapidAPI-Host"] = 'deep-translate1.p.rapidapi.com'
    request.body = "{\r
        \"q\": \"#{place}\",\r
        \"target\": \"en\"\r
    }"

    response = http.request(request)
    results=JSON.parse(response.read_body)

    results["data"]["translations"]["translatedText"]
  end

  def wikidataid
    response=HTTP.get("https://en.wikipedia.org/w/api.php", :params=>{:action=>'query',:prop=>'pageprops',:titles=>translate_the_place,:format=>'json'})
    results=JSON.parse(response)
    x=results["query"]["pages"].to_s
    y=x.split("\"")
    results["query"]["pages"]["#{y[1]}"]["pageprops"]["wikibase_item"]
  end
=end
  def destid
    place=params[:name].downcase.capitalize()
    if place.include? "%20"
      arr=place.split("%20")
      place=""
      arr.each do |name|
        place=place+name+" "
      end
    end
    response=HTTP.get("https://booking-com.p.rapidapi.com/v1/hotels/locations", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'booking-com.p.rapidapi.com'}, :params=>{:locale=>"en-us",:name=>"#{place}"})
    results=JSON.parse(response)
    arr=results[0]
    dataid=arr["dest_id"]
  end

  def viewmorehotels
    response=HTTP.get("https://booking-com.p.rapidapi.com/v1/hotels/search", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'booking-com.p.rapidapi.com'}, :params=>{:dest_id=>"#{destid}", :dest_type=>"city", :locale=>"en-us",:checkout_date=>"#{params[:checkoutdate]}", :checkin_date=>"#{params[:checkindate]}", :units=>"metric",:adults_number=>"#{params[:numpersone]}", :order_by=>"price", :filter_by_currency=>"EUR", :room_number=>"1"})
    results=JSON.parse(response)
    @hotels=results["result"]
  end

end
