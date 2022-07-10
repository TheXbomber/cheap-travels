class HomeController < ApplicationController

  Unsplash.configure do |config|
    config.application_access_key = "pzUPOA8ytHfwfzv3E2a8zAEuw-Gh9X2AHjv9dB0CzwM"
    config.application_secret = "hZzddCgFD2jVED-craiFSiUNh7VHrEUsY0FafKVhQjE"
    config.utm_source = "cheap_travels_app"
  end

  def airlabs_cities()
    #AIRLABS (OTTIENE I DATI DI TUTTE LE CITTA)
    airlabs_c=HTTP.get("https://airlabs.co/api/v9/cities?api_key=d01fc788-33b2-4e75-b59d-10b85ec931ba")
    @cities=JSON.parse(airlabs_c)["response"]
  end

  def cities_for_select
    airlabs_cities()
    @cities_select = @cities.map {|c| [ c['name'],  c['city_code'] ] }
    @cities_update = @cities.map { |c| [ c['city_code'],  c['name'] ]}.to_h
  end


  def index 
    @destinations = Destination.all
    cities_for_select
    @photo_home = {}
    @destinations.each do |dest|
      @photos_unsplash = Unsplash::Photo.search("#{dest.name}-city-landscape")
      @photo_home[dest.iata] = @photos_unsplash[rand(2)]["urls"]["regular"]
    end
  end

  def update_dest
    cities_for_select
    (1...5).each do |id|
      @dest = Destination.find(id)

      @dest.update(name: @cities_update[params["city#{id}"]], iata: params["city#{id}"])
      @dest.save
    end
    #@dest1.update(name: params["city1"][0], iata: params["city1"][1], countrycode: params["city1"][2])
    redirect_back(fallback_location: root_path)
  end

end
