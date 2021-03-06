# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Destination.create(:id => "1", :name => "Rome", :iata => "FCO", :countrycode => "IT")
Destination.create(:id => "2", :name => "New York", :iata => "JFK", :countrycode => "US")
Destination.create(:id => "3", :name => "Tokyo", :iata => "HND", :countrycode => "JP")
Destination.create(:id => "4", :name => "Sydney", :iata => "SYD", :countrycode => "AUS")

User.create(:email => "admin@admin.com", :password => "adminpass", :password_confirmation => "adminpass", :name => "Admin", :role => "admin", :favourites => "")