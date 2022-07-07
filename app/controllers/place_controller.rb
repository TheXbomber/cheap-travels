require 'uri'
require 'net/http'
require 'openssl'

class PlaceController < ApplicationController
  def index
    @destinationplace=params[:destinationplace].downcase.capitalize()
    if @destinationplace.include? "%20"
      arr=@destinationplace.split("%20")
      @destinationplace=""
      arr.each do |name|
        @destinationplace=@destinationplace+name+" "
      end
    end

    originplace=params[:originplace].downcase.capitalize()
    if originplace.include? "%20"
      arr=originplace.split("%20")
      originplace=""
      arr.each do |name|
        originplace=originplace+name+" "
      end
    end

    @country=""
    #trova le info sulla città
    response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/cities/#{wikidataid (@destinationplace)}", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
    results=JSON.parse(response)
    if results.keys[0]=="errors" #non è una città
      sleep 1 #INSERITO PER NON ECCEDERE IL NUMERO DI RICHIESTE/SEC DELLA VERSIONE GRATUITA DI GEO-DB
      response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/countries/#{wikidataid (@destinationplace)}", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
      results=JSON.parse(response)
      if results.keys[0]=="errors" #non è una nazione
        @errorinfo="Non è stato possibile trovare informazioni su #{@destinationplace}"
      else
        #se è una nazione
        @type="Nazione"
        @country=@destinationplace
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

    #PRENDE L'IMMAGINE DELLA CITTà
    response=HTTP.get("https://pixabay.com/api/", :params=>{:key=>"28482200-fa6da61f3cb68d66c0df9caf9", :q=>"#{@destinationplace}", :lang=>"en", :category=>"places", :safesearch=>"true", :per_page=>"3"})
    results=JSON.parse(response)
    @imageurl=results["hits"][0]["largeImageURL"]

    #CHIAMA LA FUNZIONE CHE GLI RESTITUISCE UN ARRAY DI 20 HOTEL
    #@hotels=gethotels

    #CHIAMA LA FUNZIONE CHE GLI RESTITUISCE I VOLI
    #getflights
  end

  def wikidataid (place) #DA TOGLIERE PER LASCIARE LA VERSIONE ORIGINALE
    response=HTTP.get("https://en.wikipedia.org/w/api.php", :params=>{:action=>'query',:prop=>'pageprops',:titles=>place,:format=>'json'})
    results=JSON.parse(response)
    x=results["query"]["pages"].to_s
    y=x.split("\"")
    results["query"]["pages"]["#{y[1]}"]["pageprops"]["wikibase_item"]
  end

=begin  #VERSIONE ORIGINALE
  def translate_the_place (place)
    #VIENE USATO PERCHÈ WIKIPEDIA VUOLE IL NOME DELLA CITTà IN INGLESE
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

  def wikidataid (place)
    #VIENE USATO PER TROVARE INFO SULLE CITTà
    response=HTTP.get("https://en.wikipedia.org/w/api.php", :params=>{:action=>'query',:prop=>'pageprops',:titles=>"#{translate_the_place place}",:format=>'json'})
    results=JSON.parse(response)
    x=results["query"]["pages"].to_s
    y=x.split("\"")
    results["query"]["pages"]["#{y[1]}"]["pageprops"]["wikibase_item"]
  end
=end

  def destid place
    #È UNO DEI PARAMETRI PER TROVARE GLI HOTEL
    response=HTTP.get("https://booking-com.p.rapidapi.com/v1/hotels/locations", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'booking-com.p.rapidapi.com'}, :params=>{:locale=>"en-us",:name=>"#{place}"})
    results=JSON.parse(response)
    arr=results[0]
    dataid=arr["dest_id"]
  end

  def gethotels
    @destinationplace=params[:destinationplace].downcase.capitalize()
    if @destinationplace.include? "%20"
      arr=@destinationplace.split("%20")
      @destinationplace=""
      arr.each do |name|
        @destinationplace=@destinationplace+name+" "
      end
    end
    response=HTTP.get("https://booking-com.p.rapidapi.com/v1/hotels/search", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'booking-com.p.rapidapi.com'}, :params=>{:dest_id=>"#{destid (@destinationplace)}", :dest_type=>"city", :locale=>"en-us",:checkout_date=>"#{params[:checkoutdate]}", :checkin_date=>"#{params[:checkindate]}", :units=>"metric",:adults_number=>"#{params[:numpersone]}", :order_by=>"price", :filter_by_currency=>"EUR", :room_number=>"1"})
    results=JSON.parse(response)
    @hotels=results["result"]
  end

  def countrycode (place)
    output=""
    sleep 1 #INSERITO PER NON ECCEDERE IL NUMERO DI RICHIESTE/SEC DELLA VERSIONE GRATUITA DI GEO-DB
    response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/cities/#{wikidataid (place)}", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
    results=JSON.parse(response)
    if results.keys[0]=="errors" #non è una città
      sleep 1 #INSERITO PER NON ECCEDERE IL NUMERO DI RICHIESTE/SEC DELLA VERSIONE GRATUITA DI GEO-DB
      response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/countries/#{wikidataid (place)}", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
      results=JSON.parse(response)
      if results.keys[0]!="errors" && results.keys[0]!="message"#se è una nazione
        output=results["data"]["code"]
      elsif results.keys[0]=="message"
        @message="You have exceeded the rate limit per second for your plan, BASIC, by the API provider"
      end
    elsif results.keys[0]=="message"
      @message="You have exceeded the rate limit per second for your plan, BASIC, by the API provider"
    else
      #se è una città
      output=results["data"]["countryCode"]
    end
    output
  end

  def iata_code (origin, destination)
    origincountrycode=countrycode origin
    destinationcountrycode=countrycode destination
    destinationiatacode=""
    originiatacode=""
    if origincountrycode!=""
      if destinationcountrycode!=""
        response=HTTP.get("https://api.travelpayouts.com/data/en/cities.json", :headers=>{"X-Access-Token"=>'ea6f6d4a8d0b1be515fca155675970bb'})
        results=JSON.parse(response)
        results.each do |elem|
          if elem["name"]==destination
            if elem["country_code"]==destinationcountrycode
              destinationiatacode=elem["code"]
            end
          end
          if elem["name"]==origin
            if elem["country_code"]==origincountrycode
              originiatacode=elem["code"]
            end
          end
        end
      end
    end
    output=[originiatacode, destinationiatacode]
  end

  def getflights
    #TROVA I VOLI
    @destinationplace=params[:destinationplace].downcase.capitalize()
    if @destinationplace.include? "%20"
      arr=@destinationplace.split("%20")
      @destinationplace=""
      arr.each do |name|
        @destinationplace=@destinationplace+name+" "
      end
    end

    originplace=params[:originplace].downcase.capitalize()
    if originplace.include? "%20"
      arr=originplace.split("%20")
      originplace=""
      arr.each do |name|
        originplace=originplace+name+" "
      end
    end

    @iataarr=iata_code originplace, @destinationplace
    puts @iataarr

    #PRENDE IL TOKEN DA AMADEUS
    url = URI("https://test.api.amadeus.com/v1/security/oauth2/token")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request.body = "client_id=vekSTCdgC3urGqAhreQlRXA8EBMgGkjS&client_secret=hkFGCQVxWBUkTsLL&grant_type=client_credentials"

    response = https.request(request)
    results=JSON.parse(response.read_body)

    #FA LA RICHIESTA DEI VOLI
    response=HTTP.get("https://test.api.amadeus.com/v2/shopping/flight-offers",:headers=>{'Authorization'=>"#{results["token_type"]} #{results["access_token"]}"}, :params=>{:originLocationCode=>"#{@iataarr[0]}", :destinationLocationCode=>"#{@iataarr[1]}", :departureDate=>"#{params[:checkindate]}", :returnDate=>"#{params[:checkoutdate]}", :adults=>"#{params[:numpersone]}", :currencyCode=>"EUR"})
    @dativoli=JSON.parse(response)
    @voliarr=@dativoli["data"]
    @numerovoli=@voliarr.length
    @arritinerarioandataeritorno=[]
    @arrvoliandata=[]
    @arrvoliritorno=[]
    @arrnumeroscaliandata=[]
    @arrnumeroscaliritorno=[]
    (0...@numerovoli).each do |k|
      elem=@voliarr[k]
      @arritinerarioandataeritorno[k]=elem["itineraries"]

      elem=@arritinerarioandataeritorno[k]
      @arrvoliandata[k]=elem[0]
      @arrvoliritorno[k]=elem[1]

      elem=@arrvoliandata[k]
      elem=elem["segments"]
      @arrnumeroscaliandata[k]=elem.length-1

      elem=@arrvoliritorno[k]
      elem=elem["segments"]
      @arrnumeroscaliritorno[k]=elem.length-1
    end
  end

  def add_to_favourites
    #before_action :authenticate_user!
    @user = User.find(current_user.id)
    if !@user.favourites.include? params[:place]
      str = @user.favourites
      if str==""
        str+=params[:place]
      else
        str=str+","+params[:place]
      end
      @user.update(favourites: str)
      @user.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def remove_from_favourites
    #before_action :authenticate_user!
    @user = User.find(current_user.id)
    if !@user.favourites.include? params[:place]
      redirect_back(fallback_location: root_path)
    else
      str=""
      if @user.favourites.include? ","
        arr=@user.favourites.split(",")
        arr.delete(params[:place])
        (0...arr.length).each do |i|
          if (i==arr.length-1)
            str=str+arr[i]
          else
            str=str+arr[i]+","
          end
        end
      end
      @user.update(favourites: str)
      @user.save
      redirect_back(fallback_location: root_path)
    end
  end
end