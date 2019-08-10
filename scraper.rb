require './config/environment'
require 'pry'
require 'nokogiri'
require 'open-uri'

class Scraper
    BASEPATH = 'https://www.atlasobscura.com/destinations'

    # global_regions = self.scrape_global_region
    # regions_and_countries = self.get_country(global_regions)
    # countries = self.scrape_country_url
    # regions_countries_states = self.scrape_country_page(countries, regions_and_countries)

    def self.scrape_page
        Nokogiri::XML(open(BASEPATH))
    end

    def self.get_global_region
        self.scrape_page.xpath('//div/div[2]/section/ul/li/div/h2/text()')
    end
        
    #global_regions variable
    def self.scrape_global_region
        global_region = {}
        self.get_global_region.each do |xml|
            text = xml.inner_text.strip!
            if text != ""
                global_region[text] = {}
                # global_region = {
                    # region: { }
                # }
            end
        end
        global_region
    end

    global_regions = self.scrape_global_region

    def self.global_region_formatted
        global_regions_formatted = []
        self.scrape_global_region.each do |region, hash|
            region = region.downcase.gsub(" ", "-").concat("-children")
            global_regions_formatted << region
        end
        global_regions_formatted
    end

    #regions_and_countries variable
    def self.get_country(global_regions)
        self.global_region_formatted.each_with_index do |region_formatted, index|
            self.scrape_page.xpath('//*[@id="' + region_formatted + '"]/div/div/div/a/text()').each do |country|
                # .keys returns array of all keys. Gives us access to index.
                region_keys = global_regions.keys
                # Add country to correct region (key) in DESTINATIONS hash
                global_regions[region_keys[index]][country.inner_text] = {city: []}
            end
        end
        global_regions
    end

    # countries variable
    def self.scrape_country_url
        countries = {}
        self.global_region_formatted.each_with_index do |region_formatted, index|
            self.scrape_page.xpath('//*[@id="' + region_formatted + '"]/div/div/div/a').each do |a|
                country_url = 'https://www.atlasobscura.com' + a.attr('href')
                country_name = a.text
                countries[country_name] = country_url
            end
        end
        countries
    end

    def get_states_or_cities
        self.xpath('//*[@id="geo-child-drawer"]/div/div[3]/div/div/div[contains(@class,"geo-dropdown-item")]/a')
    end

    # country_docs variable
    def self.get_country_doc(global_regions)
        countries_and_states = {}
        self.scrape_country_url.each do |country_name, url|

            countries_and_states[country_name] = {}

            doc = Nokogiri::XML(open(url))

            states_or_cities = doc.xpath('//*[@id="geo-child-drawer"]/div/div[3]/div/div/div[contains(@class,"geo-dropdown-item")]/a')

            if states_or_cities
            
                type = doc.xpath('//*[@id="geo-dropdown-toggle"]/span').text.strip!

                if type && type.include?("Cities")
                    countries_and_states[country_name]["city"] = []
                    states_or_cities.each do |a|
                        city_name = a.text

                        countries_and_states[country_name]["city"] << city_name
                    end

                elsif type && type.include?("Territories")
                    states_or_cities.each do |a|
                        state_name = a.text
                        state_url = 'https://www.atlasobscura.com' + a.attr('href')

                        countries_and_states[country_name][state_name] = []
                    end

                end

            end

        end
        countries_and_states
    end

    # def self.scrape_country_page(global_regions)
    #     self.get_country_page(global_regions).each do |a|
    #         if page_type.text.include?("States, Territories")
    #             cities_or_states.each do |a|
    #                 state_name = a.text
    #                 state_url = 'https://www.atlasobscura.com' + a.attr('href')
    #                 self.get_country(global_regions).each do |region_key, hash_of_countries|
    #                     hash_of_countries.each do |country_key, hash|
    #                         hash[state_name] = [] if country_key == country_name
    #                     end
    #                 end
    #                 states[state_name] = state_url
    #             end
    #         elsif page_type.text.include?("Cities")
    #             cities_or_states.each do |a|
    #                 city_name = a.text
    #                 self.get_country(global_regions).each do |region_key, hash_of_countries|
    #                     hash_of_countries.each do |country_key, hash|
    #                         if country_key == country_name
    #                             hash[:city] << city_name
    #                         end
    #                     end
    #                 end
    #             end
    #         end
    #     end
    #     states
    # end

    # region = {
    #     North_America: {
    #         United_States: {
                    # Ohio: [

                    #     ]
                    # city: [

                    # ]
    #             Ohio: [
    #                 Columbus,
    #                 Dayton,
    #                 Cincinnatti
    #             ],
    #             Minnesota: [
    #                 Minneapolis,
    #                 Saint Paul,
    #                 Rochester
    #             ]
    #         },
    #         Canada: {
    #             British_Columbia: [
    #                 Vancouver
    #             ]
    #         }
    #     }
    # }

    # region_hash.each do |region, country_hash|
    #     region.each do |country, state_hash|
    #         country.each do |state, city_array|
    #             state.each do |city|
    #                 Destination.create!(city: city, state: state, country: country, region: region)
    #             end
    #         end
    #     end
    # end

    # //*[@id="geo-child-drawer"]/div/div[3]/div/h6
    # if h6/text() contains "Territories"
        # Ohio: []
    # else
        # city: []

end