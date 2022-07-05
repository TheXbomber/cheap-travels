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

    #TRAVELPAYOUT CHEAPEST FLIGHTS (voli più economici)
    #response=HTTP.get("https://api.travelpayouts.com/v1/prices/cheap", :params=>{:origin=>"AGP", :currency=>"EUR", :token=>"ea6f6d4a8d0b1be515fca155675970bb"})
    response=HTTP.get("https://api.travelpayouts.com/v1/prices/cheap?origin=agp&destination=&currency=eur&token=ea6f6d4a8d0b1be515fca155675970bb")
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
            @locations[@dest] = {}
            @locations[@dest]["name"] = @airport[i]["address"]["cityName"]
            @locations[@dest]["country"] = @airport[i]["address"]["countryName"]
            @locations[@dest]["countryCode"] = @airport[i]["address"]["countryCode"]
            @locations[@dest]["region"] = @airport[i]["address"]["regionCode"]
            @locations[@dest]["iata"] = @airport[i]["iataCode"]
            @locations[@dest]["geocode"] = [@airport[i]["geoCode"]["latitude"], @airport[i]["geoCode"]["longitude"]]
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

  
