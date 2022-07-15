class HomeController < ApplicationController

  Unsplash.configure do |config|
    config.application_access_key = Rails.application.credentials.UNSPLASH_ACCESS_KEY
    config.application_secret = Rails.application.credentials.UNSPLASH_SECRET
    config.utm_source = "cheap_travels_app"
  end

  def airlabs_cities()
    #AIRLABS (OTTIENE I DATI DI TUTTE LE CITTA)
    airlabs_c=HTTP.get("https://airlabs.co/api/v9/cities?api_key=#{Rails.application.credentials.AIRLABS_KEY}")
    @cities=JSON.parse(airlabs_c)["response"]
  end

  def cities_for_select
    airlabs_cities()
    @cities_dest = Array.new()
    @cities_select = @cities.map {|c| [ c['name'],  c['city_code'] ] }
    @cities_update = @cities.map { |c| [ c['name'], c['city_code'] ]}.to_h
    @cities.each do |city| 
      if !@cities_dest.include?(city['name'])
        @cities_dest.append(city['name'])
      end
    end
    #puts @cities_dest.inspect
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
      if params["city#{id}"]!=""
        @dest.update(iata: @cities_update[params["city#{id}"]], name: params["city#{id}"])
        @dest.save
      end
    end
    #@dest1.update(name: params["city1"][0], iata: params["city1"][1], countrycode: params["city1"][2])
    redirect_back(fallback_location: root_path)
  end

end
