# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Destination.create(:name => "Rome", :iata => "FCO", :countrycode => "IT")
Destination.create(:name => "New York", :iata => "JFK", :countrycode => "US")
Destination.create(:name => "Tokyo", :iata => "HND", :countrycode => "JP")
Destination.create(:name => "Sydney", :iata => "SYD", :countrycode => "AUS")
