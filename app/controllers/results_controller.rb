require 'uri'
require 'net/http'
require 'openssl'
require "http"

class ResultsController < ApplicationController
 
  def index

    #response=HTTP.get("https://booking-com.p.rapidapi.com/v1/hotels/search", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'booking-com.p.rapidapi.com'}, :params=>{:dest_id=>"-553173", :dest_type=>"city", :locale=>"en-us",:checkout_date=>"2022-10-01", :checkin_date=>"2022-09-30", :units=>"metric",:adults_number=>"2", :order_by=>"price", :filter_by_currency=>"EUR", :room_number=>"1"})
    #results=JSON.parse(response)
    #@hotels=results["result"]

    require 'amadeus'
    amadeus = Amadeus::Client.new({
      client_id: 'WGG9CFp9tcAAAxjdN9txErfJhXviCCoK',
      client_secret: 'v2bxNaDnO61AZKqz'
    })

    Unsplash.configure do |config|
      config.application_access_key = "pzUPOA8ytHfwfzv3E2a8zAEuw-Gh9X2AHjv9dB0CzwM"
      config.application_secret = "hZzddCgFD2jVED-craiFSiUNh7VHrEUsY0FafKVhQjE"
      config.application_redirect_uri = "https://your-application.com/oauth/callback"
      config.utm_source = "alices_terrific_client_app"
  
    end

    #TRAVELPAYOUT CHEAPEST FLIGHTS (voli più economici)
    #response=HTTP.get("https://api.travelpayouts.com/v1/prices/cheap", :params=>{:origin=>"AGP", :currency=>"EUR", :token=>"ea6f6d4a8d0b1be515fca155675970bb"})
    response=HTTP.get("https://api.travelpayouts.com/v1/prices/cheap?origin=fco&destination=&currency=eur&token=ea6f6d4a8d0b1be515fca155675970bb")
    results=JSON.parse(response)
    @flights=results["data"]
    @keys = @flights.keys
   
    
    
    @cheapest = Array.new(5, ["",0,0])
    t = 0
    
    #ORDINA E SELEZIONA LE 5 DESTINAZIONI PIU ECONOMICHE
    @keys.each do |dest|
      num= @flights[dest].keys
      num.each do |n|
        @price = @flights[dest][n]["price"]
        b=0
        (0...5).each do |j| 
            if b==0
              if t<5
                @cheapest[t] = [dest, n, @price]
                t+=1
                b=1
              else 
                if @cheapest[j][2] > @price
                  b=1
                  (j+1...5).reverse_each do |h|
                    @cheapest[h]=@cheapest[h-1]
                  end
                  @cheapest[j]= [dest, n, @price]
                end
              end
            end
          end
      end
    end

    #AMADEUS CITIES AND AIRPORT (OTTIENE I DATI SULLA CITTA DAL CODICE IATA)
    @cheap=@cheapest
    @locations = {}
    @count =0
    x = 0
    @cheap.each do |c|

      @dest = c[0]
      #@n = c[1]
      #@volo= @flights[@dest][@n]
      sleep 1
      begin
        response = amadeus.reference_data.locations.get(
          keyword: @dest,
          subType: Amadeus::Location::AIRPORT
          ).body
        results=JSON.parse(response)
        @airport = results["data"]
       
      rescue Amadeus::ResponseError => e
        raise e
      end

      
        
      #SALVA DATI CITTA
        (0...1).each do |i|
          if @airport[i]
            
            @city= @airport[i]["address"]["cityName"]
            #@city_noblank= @airport[i]["address"]["cityName"]
            #@city_noblank.gsub!(" ","-").to_s
            #@city2 = ["barcelona", "malaga", "london", "milan"]

            #unspl=HTTP.get("https://api.unsplash.com/search/photos?query=malaga&per_page=1&orientation=landscape&page=1?&client_id=6fa91622109e859b1c40218a5dead99f7262cf4f698b1e2cb89dd18fc5824d15&ar=9:3&fit=fill&fill=solid&fill-color=orange")
            #r=JSON.parse(unspl)

            @photos = Unsplash::Photo.search("#{@city}-city-landscape")
            #@p = @photos[0]["urls"]["full"]
            @locations[@dest] = {}
            @locations[@dest]["name"] = @airport[i]["address"]["cityName"]
            @locations[@dest]["country"] = @airport[i]["address"]["countryName"]
            @locations[@dest]["countryCode"] = @airport[i]["address"]["countryCode"]
            @locations[@dest]["region"] = @airport[i]["address"]["regionCode"]
            @locations[@dest]["iata"] = @airport[i]["iataCode"]
            @locations[@dest]["geocode"] = [@airport[i]["geoCode"]["latitude"], @airport[i]["geoCode"]["longitude"]]
            @locations[@dest]["photo"] =@photos[rand(1)]["urls"]["full"]
            
              #@locations[@dest]["photo"] = r["results"][0]["urls"]["full"]
            
            if x==0
              @geo_iniziale = [@airport[i]["geoCode"]["latitude"], @airport[i]["geoCode"]["longitude"]]
              x=1
            end
          end
        end
        @count +=1
      end

    end
  end

  
