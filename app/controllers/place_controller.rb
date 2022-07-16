require 'uri'
require 'net/http'
require 'openssl'

Unsplash.configure do |config|
  config.application_access_key = Rails.application.credentials.UNSPLASH_ACCESS_KEY
  config.application_secret = Rails.application.credentials.UNSPLASH_SECRET
  config.utm_source = "cheap_travels_app"
end

class PlaceController < ApplicationController
  def index
    begin
      Date.parse(params[:checkindate])
      if Date.parse(params[:checkindate]) < Date.today
        #@message="La data di partenza inserita non è valida"
        @message="Departure date is not valid"
        return
      end
    rescue 
      #@message="La data di partenza inserita non è valida"
      @message="Departure date is not valid"
      return
    else
      begin
        Date.parse(params[:checkoutdate])
        if Date.parse(params[:checkoutdate]) < Date.today 
          #@message="La data di ritorno inserita non è valida"
          @message="Arrival date is not valid"
          return 
        end
        if Date.parse(params[:checkoutdate]) < Date.parse(params[:checkindate])
          #@message="La data di ritorno non può precedere quella di andata"
          @message="Return date cannot precede departure date"
          return
        end
      rescue
        #@message="La data di ritorno inserita non è valida"
        @message="Return date is not valid"
        return
      else
        #CONTROLLO SUL NUMERO DI PERSONE
        if params[:numpersone].to_i == 0
          #@message="Il numero di persone inserito non è valido"
          @message="Number of people is not valid"
          return
        end

        #CONTROLLO SUL NOME DELLA CITTà DI DESTINAZIONE
        @destinationplace=params[:destinationplace]
        if @destinationplace.include? "%20"
          arr=@destinationplace.split("%20")
          @destinationplace=""
          arr.each do |name|
            @destinationplace=@destinationplace+name.capitalize()+" "
          end
        end
        if @destinationplace.match? /0|1|2|3|4|5|6|7|8|9/
          #@message="La città di destinazione non è valida"
          @message="Destination city is not valid"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI ORIGINE
        originplace=params[:originplace]
        if originplace.length!=3
          #@message="Iata code della città di partenza non valido"
          @message="Iata code of starting city is not valid"
        end
        if originplace.match? /0|1|2|3|4|5|6|7|8|9/ 
          #@message="Iata code della città di partenza non valido"
          @message="Iata code of starting city is not valid"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI DESTINAZIONE
        destiata=params[:destiata]
        if destiata.length!=3
          #@message="Iata code della città di destinazione non valido"
          @message="Iata code of destination city is not valid"
        end
        if destiata.match? /0|1|2|3|4|5|6|7|8|9/ 
          #@message="Iata code della città di destinazione non valido"
          @message="Iata code of destination city is not valid"
          return
        end

        #CONTROLLO SUL COUNTRY CODE DELLA CITTà DI DESTINAZIONE
        destcountry=params[:destcountry]
        if destcountry.match? /0|1|2|3|4|5|6|7|8|9/ 
          #@message="Country code della città di destinazione non valido"
          @message="Country code of destination city is not valid"
          return
        end
      end
    end

    #trova le info sulla città
    response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/cities/#{wikidataid (@destinationplace)}", :headers=>{"X-RapidAPI-Key"=>Rails.application.credentials.RAPID_API_KEY,"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
    results=JSON.parse(response)
    if results.keys[0]=="errors" #non è una città
      sleep 1 #INSERITO PER NON ECCEDERE IL NUMERO DI RICHIESTE/SEC DELLA VERSIONE GRATUITA DI GEO-DB
      response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/countries/#{wikidataid (@destinationplace)}", :headers=>{"X-RapidAPI-Key"=>Rails.application.credentials.RAPID_API_KEY,"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
      results=JSON.parse(response)
      if results.keys[0]=="errors" #non è una nazione
        @messageinfo="No info was found about #{@destinationplace}"
      else
        #se è una nazione
        @type="Nation"
        @country=@destinationplace
        @capital=results["data"]["capital"]
        @numregions=results["data"]["numRegions"]
      end
    else
      #se è una città
      @type="City"
      @country=results["data"]["country"]
      @region=results["data"]["region"]
      @elevationmeters=results["data"]["elevationMeters"]
      @population=results["data"]["population"]
      @latitude=results["data"]["latitude"]
      @longitude=results["data"]["longitude"]
    end

    #PRENDE L'IMMAGINE DELLA CITTà
    begin
      @photo_unsplash = Unsplash::Photo.search("#{@destinationplace}-city-landscape")
      if (@photo_unsplash[0] ==nil) 
        @messaggeimage="No images were found"
      end
      @imageurl= @photo_unsplash[rand(2)]["urls"]["regular"]
      puts @imageurl
    rescue
      @messaggeimage="There was an error loading the image"
      return
    end

    #CHIAMA LA FUNZIONE CHE GLI RESTITUISCE UN ARRAY DI 20 HOTEL
    #@hotels=gethotels

    #CHIAMA LA FUNZIONE CHE GLI RESTITUISCE I VOLI
    #getflights
  end

  def wikidataid (place)
    begin
      response=HTTP.get("https://en.wikipedia.org/w/api.php", :params=>{:action=>'query',:prop=>'pageprops',:titles=>place,:format=>'json'})
      results=JSON.parse(response)
    rescue
      @messageinfo="No info was found about #{@destinationplace}"
      return
    else
      x=results["query"]["pages"].to_s
      y=x.split("\"")
      if results["query"]["pages"]["#{y[1]}"].keys.include? "pageprops"
        results["query"]["pages"]["#{y[1]}"]["pageprops"]["wikibase_item"]
      else
        @messageinfo="No info was found about #{@destinationplace}"
        -1
      end
    end
  end

  def destid (place, country)
    #È UNO DEI PARAMETRI PER TROVARE GLI HOTEL
    response=HTTP.get("https://booking-com.p.rapidapi.com/v1/hotels/locations", :headers=>{"X-RapidAPI-Key"=>Rails.application.credentials.RAPID_API_KEY,"X-RapidAPI-Host"=>'booking-com.p.rapidapi.com'}, :params=>{:locale=>"en-us",:name=>"#{place}, #{country}"})
    results=JSON.parse(response)
    arr=results[0]
    dataid=arr["dest_id"]
  end

  def gethotels
    begin
      Date.parse(params[:checkindate])
      if Date.parse(params[:checkindate]) < Date.today
        #@message="La data di partenza inserita non è valida"
        @message="Departure date is not valid"
        return
      end
    rescue 
      #@message="La data di partenza inserita non è valida"
      @message="Departure date is not valid"
      return
    else
      begin
        Date.parse(params[:checkoutdate])
        if Date.parse(params[:checkoutdate]) < Date.today 
          #@message="La data di ritorno inserita non è valida"
          @message="Return date is not valid"
          return 
        end
        if Date.parse(params[:checkoutdate]) < Date.parse(params[:checkindate])
          #@message="La data di ritorno non può precedere quella di andata"
          @message="Return date cannot precede departure date"
          return
        end
      rescue
        #@message="La data di ritorno inserita non è valida"
        @message="Return date is not valid"
        return
      else
        #CONTROLLO SUL NUMERO DI PERSONE
        if params[:numpersone].to_i == 0
          #@message="Il numero di persone inserito non è valido"
          @message="Number of people is not valid"
          return
        end

        #CONTROLLO SUL NOME DELLA CITTà DI DESTINAZIONE
        @destinationplace=params[:destinationplace]
        if @destinationplace.include? "%20"
          arr=@destinationplace.split("%20")
          @destinationplace=""
          arr.each do |name|
            @destinationplace=@destinationplace+name.capitalize()+" "
          end
        end
        if @destinationplace.match? /0|1|2|3|4|5|6|7|8|9/
          #@message="La città di destinazione non è valida"
          @message="Destination city is not valid"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI ORIGINE
        originplace=params[:originplace]
        if originplace.length!=3
          #@message="Iata code della città di partenza non valido"
          @message="Iata code of starting city is not valid"
        end
        if originplace.match? /0|1|2|3|4|5|6|7|8|9/ 
          #@message="Iata code della città di partenza non valido"
          @message="Iata code of starting city is not valid"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI DESTINAZIONE
        destiata=params[:destiata]
        if destiata.length!=3
          #@message="Iata code della città di destinazione non valido"
          @message="Iata code of destination city is not valid"
        end
        if destiata.match? /0|1|2|3|4|5|6|7|8|9/ 
          #@message="Iata code della città di destinazione non valido"
          @message="Iata code of destination city is not valid"
          return
        end

        #CONTROLLO SUL COUNTRY CODE DELLA CITTà DI DESTINAZIONE
        destcountry=params[:destcountry]
        if destcountry.match? /0|1|2|3|4|5|6|7|8|9/ 
          #@message="Country code della città di destinazione non valido"
          @message="Country code of destination city is not valid"
          return
        end
      end
    end
    begin
      response=HTTP.get("https://booking-com.p.rapidapi.com/v1/hotels/search", :headers=>{"X-RapidAPI-Key"=>Rails.application.credentials.RAPID_API_KEY,"X-RapidAPI-Host"=>'booking-com.p.rapidapi.com'}, :params=>{:dest_id=>"#{destid @destinationplace, destcountry}", :dest_type=>"city", :locale=>"en-us",:checkout_date=>"#{Date.parse(params[:checkoutdate])}", :checkin_date=>"#{Date.parse(params[:checkindate])}", :units=>"metric",:adults_number=>"#{params[:numpersone]}", :order_by=>"price", :filter_by_currency=>"EUR", :room_number=>"1"})
      results=JSON.parse(response)
    rescue
      #@messagehotels="Siamo spiacenti, non sono stati trovati hotel disponibili"
      @messagehotels="Sorry, no available hotels were found"
      return
    else
      @hotels=results["result"]
    end
  end

  def getflights
    begin
      Date.parse(params[:checkindate])
      if Date.parse(params[:checkindate]) < Date.today
        #@message="La data di partenza inserita non è valida"
        @message="Departure date is not valid"
        return
      end
    rescue 
      #@message="La data di partenza inserita non è valida"
      @message="Departure date is not valid"
      return
    else
      begin
        Date.parse(params[:checkoutdate])
        if Date.parse(params[:checkoutdate]) < Date.today 
          #@message="La data di ritorno inserita non è valida"
          @message="Return date is not valid"
          return 
        end
        if Date.parse(params[:checkoutdate]) < Date.parse(params[:checkindate])
          #@message="La data di ritorno non può precedere quella di andata"
          @message="Return date cannot preced departure date"
          return
        end
      rescue
        #@message="La data di ritorno inserita non è valida"
        @message="Return date is not valid"
        return
      else
        #CONTROLLO SUL NUMERO DI PERSONE
        if params[:numpersone].to_i == 0
          #@message="Il numero di persone inserito non è valido"
          @message="Number of people is not valid"
          return
        end

        #CONTROLLO SUL NOME DELLA CITTà DI DESTINAZIONE
        @destinationplace=params[:destinationplace]
        if @destinationplace.include? "%20"
          arr=@destinationplace.split("%20")
          @destinationplace=""
          arr.each do |name|
            @destinationplace=@destinationplace+name.capitalize()+" "
          end
        end
        if @destinationplace.match? /0|1|2|3|4|5|6|7|8|9/
          #@message="La città di destinazione non è valida"
          @message="Destination city is not valid"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI ORIGINE
        originplace=params[:originplace]
        if originplace.length!=3
          #@message="Iata code della città di partenza non valido"
          @message="Country code of starting city is not valid"
        end
        if originplace.match? /0|1|2|3|4|5|6|7|8|9/ 
          #@message="Iata code della città di partenza non valido"
          @message="Country code of starting city is not valid"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI DESTINAZIONE
        destiata=params[:destiata]
        if destiata.length!=3
          #@message="Iata code della città di destinazione non valido"
          @message="Iata code of destination city is not valid"
        end
        if destiata.match? /0|1|2|3|4|5|6|7|8|9/ 
          #@message="Iata code della città di destinazione non valido"
          @message="Iata code of destination city is not valid"
          return
        end

        #CONTROLLO SUL COUNTRY CODE DELLA CITTà DI DESTINAZIONE
        destcountry=params[:destcountry]
        if destcountry.match? /0|1|2|3|4|5|6|7|8|9/ 
          #@message="Country code della città di destinazione non valido"
          @message="Country code of destination city is not valid"
          return
        end
      end
    end

    begin
      #PRENDE IL TOKEN DA AMADEUS
      url = URI("https://test.api.amadeus.com/v1/security/oauth2/token")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request.body = "client_id=#{Rails.application.credentials.FLIGHT_CLIENT_ID}&client_secret=#{Rails.application.credentials.FLIGHT_CLIENT_SECRET}&grant_type=client_credentials"

      response = https.request(request)
      results=JSON.parse(response.read_body)
    rescue
      #@messageflights="Si è verificato un errore, riprova più tardi"
      @messageflights="An error has occurred, try again later"
      return
    else
      #FA LA RICHIESTA DEI VOLI
      begin
        response=HTTP.get("https://test.api.amadeus.com/v2/shopping/flight-offers",:headers=>{'Authorization'=>"#{results["token_type"]} #{results["access_token"]}"}, :params=>{:originLocationCode=>"#{params[:originplace]}", :destinationLocationCode=>"#{params[:destiata]}", :departureDate=>"#{Date.parse(params[:checkindate])}", :returnDate=>"#{Date.parse(params[:checkoutdate])}", :adults=>"#{params[:numpersone]}", :currencyCode=>"EUR"})
        @dativoli=JSON.parse(response)
        if @dativoli["data"].empty?
          #@messageflights="Siamo spiacenti, non sono stati trovati voli disponibili"
          @messageflights="Sorry, no available flights were found"
          return
        end
      rescue
        #@messageflights="Siamo spiacenti, non sono stati trovati voli disponibili"
        @messageflights="Sorry, no available flights were found"
        return
      else
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
    end
  end

  def add_to_favourites
    #before_action :authenticate_user!
    if params[:flash_notice]=="Ok" #serve per non permettere all'utente di scrivere l'url e aggiungere la città ai preferiti e garantire che lo si può fare solo dal link
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
  end

  def remove_from_favourites
    #before_action :authenticate_user!
    if params[:flash_notice]=="Ok" #serve per non permettere all'utente di scrivere l'url e rimuovere la città dai preferiti e garantire che lo si può fare solo dal link
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
end