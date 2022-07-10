require 'uri'
require 'net/http'
require 'openssl'

class PlaceController < ApplicationController
  def index
    begin
      Date.parse(params[:checkindate])
      if Date.parse(params[:checkindate]) < Date.today
        @message="La data di partenza inserita non è valida"
        return
      end
    rescue 
      @message="La data di partenza inserita non è valida"
      return
    else
      begin
        Date.parse(params[:checkoutdate])
        if Date.parse(params[:checkoutdate]) < Date.today 
          @message="La data di ritorno inserita non è valida"
          return 
        end
        if Date.parse(params[:checkoutdate]) < Date.parse(params[:checkindate])
          @message="La data di ritorno non può precedere quella di andata"
          return
        end
      rescue
        @message="La data di ritorno inserita non è valida"
        return
      else
        #CONTROLLO SUL NUMERO DI PERSONE
        if params[:numpersone].to_i == 0
          @message="Il numero di persone inserito non è valido"
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
          @message="La città di destinazione non è valida"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI ORIGINE
        originplace=params[:originplace]
        if originplace.length!=3
          @message="Iata code della città di partenza non valido"
        end
        if originplace.match? /0|1|2|3|4|5|6|7|8|9/ 
          @message="Iata code della città di partenza non valido"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI DESTINAZIONE
        destiata=params[:destiata]
        if destiata.length!=3
          @message="Iata code della città di destinazione non valido"
        end
        if destiata.match? /0|1|2|3|4|5|6|7|8|9/ 
          @message="Iata code della città di destinazione non valido"
          return
        end

        #CONTROLLO SUL COUNTRY CODE DELLA CITTà DI DESTINAZIONE
        destcountry=params[:destcountry]
        if destcountry.match? /0|1|2|3|4|5|6|7|8|9/ 
          @message="Country code della città di destinazione non valido"
          return
        end
      end
    end

    @country=""
    #trova le info sulla città
    response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/cities/#{wikidataid (@destinationplace)}", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
    results=JSON.parse(response)
    puts results
    if results.keys[0]=="errors" #non è una città
      sleep 1 #INSERITO PER NON ECCEDERE IL NUMERO DI RICHIESTE/SEC DELLA VERSIONE GRATUITA DI GEO-DB
      response=HTTP.get("https://wft-geo-db.p.rapidapi.com/v1/geo/countries/#{wikidataid (@destinationplace)}", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'wft-geo-db.p.rapidapi.com'})
      results=JSON.parse(response)
      if results.keys[0]=="errors" #non è una nazione
        @errorinfo="Non è stato possibile trovare informazioni su #{@destinationplace}"
      else
        #se è una nazione
        @type="Nazione"
        @country=@destinationplace
        @capital=results["data"]["capital"]
        @numregions=results["data"]["numRegions"]
      end
    else
      #se è una città
      @type="Città"
      @country=results["data"]["country"]
      @region=results["data"]["region"]
      @elevationmeters=results["data"]["elevationMeters"]
      @population=results["data"]["population"]
      @latitude=results["data"]["latitude"]
      @longitude=results["data"]["longitude"]
    end

    #PRENDE L'IMMAGINE DELLA CITTà
    begin
      response=HTTP.get("https://pixabay.com/api/", :params=>{:key=>"28482200-fa6da61f3cb68d66c0df9caf9", :q=>"#{@destinationplace} city landscape", :lang=>"en", :category=>"places", :safesearch=>"true", :per_page=>"3"})
      results=JSON.parse(response)
      if results["total"]<1
        @messageimage="C'è stato un errore nel caricamento dell'immagine"
      end
      @imageurl=results["hits"][0]["largeImageURL"]
    rescue
      @messaggeimage="C'è stato un errore nel caricamento dell'immagine"
      return
    end

    #CHIAMA LA FUNZIONE CHE GLI RESTITUISCE UN ARRAY DI 20 HOTEL
    @hotels=gethotels

    #CHIAMA LA FUNZIONE CHE GLI RESTITUISCE I VOLI
    getflights
  end

  def wikidataid (place) #DA TOGLIERE PER LASCIARE LA VERSIONE ORIGINALE
    response=HTTP.get("https://en.wikipedia.org/w/api.php", :params=>{:action=>'query',:prop=>'pageprops',:titles=>place,:format=>'json'})
    results=JSON.parse(response)
    x=results["query"]["pages"].to_s
    y=x.split("\"")
    results["query"]["pages"]["#{y[1]}"]["pageprops"]["wikibase_item"]
  end

=begin  #VERSIONE ORIGINALE
  def translate_the_place (place)
    #VIENE USATO PERCHÈ WIKIPEDIA VUOLE IL NOME DELLA CITTà IN INGLESE
    url = URI("https://deep-translate1.p.rapidapi.com/language/translate/v2")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request["X-RapidAPI-Key"] = 'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226'
    request["X-RapidAPI-Host"] = 'deep-translate1.p.rapidapi.com'
    request.body = "{\r
        \"q\": \"#{place}\",\r
        \"target\": \"en\"\r
    }"

    response = http.request(request)
    results=JSON.parse(response.read_body)

    results["data"]["translations"]["translatedText"]
  end

  def wikidataid (place)
    #VIENE USATO PER TROVARE INFO SULLE CITTà
    response=HTTP.get("https://en.wikipedia.org/w/api.php", :params=>{:action=>'query',:prop=>'pageprops',:titles=>"#{translate_the_place place}",:format=>'json'})
    results=JSON.parse(response)
    x=results["query"]["pages"].to_s
    y=x.split("\"")
    results["query"]["pages"]["#{y[1]}"]["pageprops"]["wikibase_item"]
  end
=end

  def destid (place, country)
    #È UNO DEI PARAMETRI PER TROVARE GLI HOTEL
    response=HTTP.get("https://booking-com.p.rapidapi.com/v1/hotels/locations", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'booking-com.p.rapidapi.com'}, :params=>{:locale=>"en-us",:name=>"#{place}, #{country}"})
    results=JSON.parse(response)
    arr=results[0]
    dataid=arr["dest_id"]
  end

  def gethotels
    begin
      Date.parse(params[:checkindate])
      if Date.parse(params[:checkindate]) < Date.today
        @message="La data di partenza inserita non è valida"
        return
      end
    rescue 
      @message="La data di partenza inserita non è valida"
      return
    else
      begin
        Date.parse(params[:checkoutdate])
        if Date.parse(params[:checkoutdate]) < Date.today 
          @message="La data di ritorno inserita non è valida"
          return 
        end
        if Date.parse(params[:checkoutdate]) < Date.parse(params[:checkindate])
          @message="La data di ritorno non può precedere quella di andata"
          return
        end
      rescue
        @message="La data di ritorno inserita non è valida"
        return
      else
        #CONTROLLO SUL NUMERO DI PERSONE
        if params[:numpersone].to_i == 0
          @message="Il numero di persone inserito non è valido"
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
          @message="La città di destinazione non è valida"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI ORIGINE
        originplace=params[:originplace]
        if originplace.length!=3
          @message="Iata code della città di partenza non valido"
        end
        if originplace.match? /0|1|2|3|4|5|6|7|8|9/ 
          @message="Iata code della città di partenza non valido"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI DESTINAZIONE
        destiata=params[:destiata]
        if destiata.length!=3
          @message="Iata code della città di destinazione non valido"
        end
        if destiata.match? /0|1|2|3|4|5|6|7|8|9/ 
          @message="Iata code della città di destinazione non valido"
          return
        end

        #CONTROLLO SUL COUNTRY CODE DELLA CITTà DI DESTINAZIONE
        destcountry=params[:destcountry]
        if destcountry.match? /0|1|2|3|4|5|6|7|8|9/ 
          @message="Country code della città di destinazione non valido"
          return
        end
      end
    end
    begin
      response=HTTP.get("https://booking-com.p.rapidapi.com/v1/hotels/search", :headers=>{"X-RapidAPI-Key"=>'a1e0b78f93mshde8dafd691a0df9p199ec6jsn8521ec4e8226',"X-RapidAPI-Host"=>'booking-com.p.rapidapi.com'}, :params=>{:dest_id=>"#{destid @destinationplace, destcountry}", :dest_type=>"city", :locale=>"en-us",:checkout_date=>"#{Date.parse(params[:checkoutdate])}", :checkin_date=>"#{Date.parse(params[:checkindate])}", :units=>"metric",:adults_number=>"#{params[:numpersone]}", :order_by=>"price", :filter_by_currency=>"EUR", :room_number=>"1"})
      results=JSON.parse(response)
    rescue
      @messagehotels="Siamo spiacenti, non sono stati trovati hotel disponibili"
      return
    else
      @hotels=results["result"]
    end
  end

  def getflights
    begin
      Date.parse(params[:checkindate])
      if Date.parse(params[:checkindate]) < Date.today
        @message="La data di partenza inserita non è valida"
        return
      end
    rescue 
      @message="La data di partenza inserita non è valida"
      return
    else
      begin
        Date.parse(params[:checkoutdate])
        if Date.parse(params[:checkoutdate]) < Date.today 
          @message="La data di ritorno inserita non è valida"
          return 
        end
        if Date.parse(params[:checkoutdate]) < Date.parse(params[:checkindate])
          @message="La data di ritorno non può precedere quella di andata"
          return
        end
      rescue
        @message="La data di ritorno inserita non è valida"
        return
      else
        #CONTROLLO SUL NUMERO DI PERSONE
        if params[:numpersone].to_i == 0
          @message="Il numero di persone inserito non è valido"
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
          @message="La città di destinazione non è valida"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI ORIGINE
        originplace=params[:originplace]
        if originplace.length!=3
          @message="Iata code della città di partenza non valido"
        end
        if originplace.match? /0|1|2|3|4|5|6|7|8|9/ 
          @message="Iata code della città di partenza non valido"
          return
        end

        #CONTROLLO SULLO IATACODE DELLA CITTà DI DESTINAZIONE
        destiata=params[:destiata]
        if destiata.length!=3
          @message="Iata code della città di destinazione non valido"
        end
        if destiata.match? /0|1|2|3|4|5|6|7|8|9/ 
          @message="Iata code della città di destinazione non valido"
          return
        end

        #CONTROLLO SUL COUNTRY CODE DELLA CITTà DI DESTINAZIONE
        destcountry=params[:destcountry]
        if destcountry.match? /0|1|2|3|4|5|6|7|8|9/ 
          @message="Country code della città di destinazione non valido"
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
      request.body = "client_id=vekSTCdgC3urGqAhreQlRXA8EBMgGkjS&client_secret=hkFGCQVxWBUkTsLL&grant_type=client_credentials"

      response = https.request(request)
      results=JSON.parse(response.read_body)
    rescue
      @messageflights="Si è verificato un errore, riprova più tardi"
      return
    else
      #FA LA RICHIESTA DEI VOLI
      begin
        response=HTTP.get("https://test.api.amadeus.com/v2/shopping/flight-offers",:headers=>{'Authorization'=>"#{results["token_type"]} #{results["access_token"]}"}, :params=>{:originLocationCode=>"#{params[:originplace]}", :destinationLocationCode=>"#{params[:destiata]}", :departureDate=>"#{Date.parse(params[:checkindate])}", :returnDate=>"#{Date.parse(params[:checkoutdate])}", :adults=>"#{params[:numpersone]}", :currencyCode=>"EUR"})
        @dativoli=JSON.parse(response)
        if @dativoli["data"].empty?
          @messageflights="Siamo spiacenti, non sono stati trovati voli disponibili"
          return
        end
      rescue
        @messageflights="Siamo spiacenti, non sono stati trovati voli disponibili"
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