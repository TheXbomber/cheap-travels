require "http"

class PlaceController < ApplicationController
  def index
    response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/cities/Q60", :params=>{:X-RapidAPI-Key=>'',:X-RapidAPI-Host=>'wft-geo-db.p.rapidapi.com'})
    results=response.parse['body']
  end
end
