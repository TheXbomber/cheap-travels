require 'rails_helper'
# def cheapest_flights(origin, departure)
#   @flights_not_found=false
#   begin
#     #TRAVELPAYOUT CHEAPEST FLIGHTS (voli più economici)
#     #response=HTTP.get("https://api.travelpayouts.com/v1/prices/cheap", :params=>{:origin=>"AGP", :currency=>"EUR", :token=>"ea6f6d4a8d0b1be515fca155675970bb"})
#     response=HTTP.get("https://api.travelpayouts.com/v1/prices/cheap?origin=#{origin}&depart_date=#{departure}&currency=eur&token=#{Rails.application.credentials.TRAVELPAYOUTS_KEY}")
#     results=JSON.parse(response)
#   rescue
#     @flights_not_found = true
#     return
#   else
#     @flights=results["data"] 
#     if @flights == nil
#       @flights_not_found = true
#     else
#       @keys = @flights.keys
#       @numero_d = @keys.count
#       @cheapest = Array.new()
#       @arrival_departure = Array.new()    
#     end  
#   end
# end

# def airlabs_iata(iata_code)
#   #AIRLABS (OTTIENE I DATI SULLA CITTA DAL CODICE IATA)
#   airlabs=HTTP.get("https://airlabs.co/api/v9/cities?city_code=#{iata_code}&api_key=#{Rails.application.credentials.AIRLABS_KEY}")
#   @airport=JSON.parse(airlabs)["response"]
# end

# def index

#   Unsplash.configure do |config|
#     config.application_access_key = Rails.application.credentials.UNSPLASH_ACCESS_KEY
#     config.application_secret = Rails.application.credentials.UNSPLASH_SECRET
#     config.utm_source = "cheap_travels_app"
#   end
  
#   cheapest_flights(params["search"]["origin"], params["search"]["departure"])
#   if @flights_not_found==false
#     inseriti = 0
#     #ORDINA E SELEZIONA LE 5 DESTINAZIONI PIU ECONOMICHE
#     @keys.each do |dest|
#       num= @flights[dest].keys
#       assegnato=0
#       num.each do |n|
#         if assegnato==0
#           @price = @flights[dest][n]["price"]
#           if @price < params["search"]["budget"].to_i
#             a=0
#             (0...5).each do |j|
#                 if a==0  
#                   if inseriti<5
#                     @cheapest.append([dest, n, @price])
#                     inseriti+=1
#                     assegnato=1
#                     a=1
#                   else 
#                     if @cheapest[j][2] > @price
#                       assegnato=1
#                       a=1
#                       (j+1...5).reverse_each do |h|
#                         @cheapest[h]=@cheapest[h-1]
#                       end
#                       @cheapest[j]= [dest, n, @price]
#                     end
#                   end
#                 end
#             end
#           end
#         end
#       end
#     end

#     @cheap=@cheapest  
#     @locations = {}
#     @count =0
#     x = 0

#     @cheap.each do |c|
#       @dest = c[0]
#       #arrival= @flights[c[0]][c[1]]['departure_at'].to_s.split('T')
#       #departure = @flights[c[0]][c[1]]['arrival_at'].to_s.split('T')
#       #@arrival_departure.append([arrival.first, departure.first])
#       #puts @arrival_departure
#       airlabs_iata(@dest)   
    
        
#       #SALVA DATI CITTA
#         (0...1).each do |i|
#           if @airport[i]
            
#             @city= @airport[i]["name"]
#             #@city_noblank= @airport[i]["address"]["cityName"]
#             #@city_noblank.gsub!(" ","-").to_s
#             #@city2 = ["barcelona", "malaga", "london", "milan"]

#             @photos = Unsplash::Photo.search("#{@city}-city-landscape")
#             @locations[@dest] = {}
#             @locations[@dest]["name"] = @airport[i]["name"]
#             @locations[@dest]["countryCode"] = @airport[i]["country_code"]
#             #@locations[@dest]["region"] = @airport[i]["address"]["regionCode"]
#             @locations[@dest]["iata"] = @airport[i]["city_code"]
#             @locations[@dest]["geocode"] = [@airport[i]["lat"], @airport[i]["lng"]]
#             @locations[@dest]["photo"] =@photos[rand(2)]["urls"]["regular"]
            
#             #@locations[@dest]["photo"] = r["results"][0]["urls"]["full"]
            
#             if x==0
#               @geo_iniziale = [@airport[i]["lat"], @airport[i]["lng"]]
#               x=1
#             end
#           end
#         end
#         @count +=1
#       end
#     end
#   end
# end

# RSpec.describe ResultsController, type: :controller do
#   describe ".index" do
#     origin = "BER"
#     departure = "2022-08-01"
#     cheapest_flights(origin, departure)
#   end
# end