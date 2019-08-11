require 'rubygems'
require 'bundler/setup'
require 'open-uri'
require './scraper'

# @global_regions = Scraper.scrape_global_region

# @regions_and_countries = Scraper.get_country(global_regions)

# @countries = Scraper.scrape_country_url
global_regions = Scraper.scrape_global_region
regions_and_countries = Scraper.get_country(global_regions)
countries = Scraper.scrape_country_url
#regions_countries_states = Scraper.scrape_country_page(regions_and_countries)

scrape = Scraper.scrape_country

binding.pry

puts 'hello'