class HomeController < ApplicationController

  Unsplash.configure do |config|
    config.application_access_key = "pzUPOA8ytHfwfzv3E2a8zAEuw-Gh9X2AHjv9dB0CzwM"
    config.application_secret = "hZzddCgFD2jVED-craiFSiUNh7VHrEUsY0FafKVhQjE"
    config.utm_source = "cheap_travels_app"
  end

  def airlabs_cities()
    #AIRLABS (OTTIENE I DATI DI TUTTE LE CITTA)
    airlabs_c=HTTP.get("https://airlabs.co/api/v9/cities?api_key=06ec0991-7aff-487e-a815-9eab333258f4")
    @cities=JSON.parse(airlabs_c)["response"]
  end

  def cities_for_select
    airlabs_cities()
    @cities_select = @cities.map {|c| [ c['name'], c['country_code'] ] }
  end


  def index 

    cities_for_select

    @home_cities = [["Roma", "AGP"], ["Malaga", "AGP"], ["Milano", "LIN"], ["Parigi", "ORY"]]
    @photo_home = ["", "", "", ""]
      (0...4).each do |i|
        @photos_unsplash = Unsplash::Photo.search("#{@home_cities[i][0]}-city-landscape")
        @photo_home[i] = @photos_unsplash[rand(2)]["urls"]["regular"]
      end
    

  end
end
