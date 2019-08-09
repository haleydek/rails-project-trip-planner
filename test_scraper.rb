require 'rubygems'
require 'bundler/setup'
require 'open-uri'
require './scraper'

scrape = Scraper.get_country

binding.pry

puts 'hello'