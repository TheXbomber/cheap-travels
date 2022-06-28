require "http"

class PlaceController < ApplicationController
  def index
    response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/cities/Q60", :params=>{:X-RapidAPI-Key=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',:X-RapidAPI-Host=>'wft-geo-db.p.rapidapi.com'})
    results=response.parse['body']
  end
end
