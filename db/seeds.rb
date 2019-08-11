# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative '../scraper'

destinations = Scraper.scrape_country

destinations.each do |region, region_hash|
    region_hash.each do |country, country_hash|
        if country_hash.empty?
            Destination.create!(region: region, country: country)
        else
            country_hash.each do |state_or_city, hash_or_array|
                if state_or_city == "state"
                    hash_or_array.each do |state, city_array|
                        if !city_array.empty?
                            city_array.each do |city|
                                Destination.create!(region: region, country: country, state: state, city: city)
                            end
                        else
                            Destination.create!(region: region, country: country, state: state)
                        end
                    end
                elsif state_or_city == "city"
                    if !hash_or_array.empty?
                        hash_or_array.each do |city|
                            Destination.create!(region: region, country: country, city: city)
                        end
                    else
                        Destination.create!(region: region, country: country)
                    end
                else
                    Destination.create!(region: region, country: country)
                end
            end
        end
    end
end