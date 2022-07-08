class HomeController < ApplicationController

  Unsplash.configure do |config|
    config.application_access_key = "pzUPOA8ytHfwfzv3E2a8zAEuw-Gh9X2AHjv9dB0CzwM"
    config.application_secret = "hZzddCgFD2jVED-craiFSiUNh7VHrEUsY0FafKVhQjE"
    config.utm_source = "cheap_travels_app"
  end

  def index 

    @home_cities = [["Roma", "AGP"], ["Malaga", "AGP"], ["Milano", "LIN"], ["Parigi", "ORY"]]
    @photo_home = ["", "", "", ""]
      (0...4).each do |i|
        @photos_unsplash = Unsplash::Photo.search("#{@home_cities[i][0]}-city-landscape")
        @photo_home[i] = @photos_unsplash[rand(2)]["urls"]["regular"]
      end
    

  end
end
