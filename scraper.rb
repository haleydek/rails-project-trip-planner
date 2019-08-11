require './config/environment'
require 'pry'
require 'nokogiri'
require 'open-uri'

class Scraper
    BASEPATH = 'https://www.atlasobscura.com/destinations'

    def self.scrape_page
        Nokogiri::XML(open(BASEPATH))
    end

    def self.get_global_region
        self.scrape_page.xpath('//div/div[2]/section/ul/li/div/h2/text()')
    end
        
    #destinatinos variable
    def self.scrape_global_region
        global_region = {}
        self.get_global_region.each do |region|
            region_name = region.inner_text.strip!
            if region_name != ""
                global_region[region_name] = {}
                # global_region = {
                    # region: { }
                # }
            end
        end
        global_region
    end

    def self.global_region_formatted
        global_regions_formatted = []
        self.scrape_global_region.each do |region, hash|
            region = region.downcase.gsub(" ", "-").concat("-children")
            global_regions_formatted << region
        end
        global_regions_formatted
    end

    def self.format_global_region(region)
        region.downcase.gsub(" ", "-").concat("-children")
    end

    def self.scrape_country
        destinations = self.scrape_global_region
        self.scrape_global_region.each do |region, country_hash|
            # formatted region name in order to scrape countries
            formatted_region = self.format_global_region(region)
            #scrape each country using formatted_region name
            self.scrape_page.xpath('//*[@id="' + formatted_region + '"]/div/div/div/a').each do |country|
                country_url = 'https://www.atlasobscura.com' + country.attr('href')
                country_name = country.text

                destinations[region][country_name] = {}

                country_page = Nokogiri::XML(open(country_url))

                states_or_cities = country_page.xpath('//*[@id="geo-child-drawer"]/div/div[3]/div/div/div[contains(@class,"geo-dropdown-item")]/a')

                if states_or_cities.text
            
                    type = country_page.xpath('//*[@id="geo-dropdown-toggle"]/span').text.strip!

                    if type && type.include?("Cities")
                        destinations[region][country_name]["city"] = []
                        states_or_cities.each do |a|
                            city_name = a.text

                            destinations[region][country_name]["city"] << city_name
                        end

                    elsif type && type.include?("Territories")
                        destinations[region][country_name]["state"] = {}
                        states_or_cities.each do |a|
                            state_name = a.text
                            state_url = 'https://www.atlasobscura.com' + a.attr('href')

                            destinations[region][country_name]["state"][state_name] = []

                            state_doc = Nokogiri::XML(open(state_url))

                            cities = state_doc.xpath('//*[@id="geo-child-drawer"]/div/div[3]/div/div/div[contains(@class,"geo-dropdown-item")]/a')

                            cities.each do |city|
                                city_name = city.text

                                destinations[region][country_name]["state"][state_name] << city_name
                            end
                        end

                    end
                end

            end
        end
        destinations
    end

    # destionations = {
    #     North_America: {
    #         United_States: {
                    # state: {
                    #     Ohio: [
                    #         Columbus
                    #     ],
                    # },
            #  France: {
            #         city: [
            #              Paris,
            #              Normandy
            #          ]
            #      }
    #         }
    #     }
    # }

    # destinations.each do |region, region_hash|
    #     region.each do |country, country_hash|
    #         if country_hash.empty?
    #             Destiantion.create!(region: region, country: country)
    #         else
    #             country.each do |state_or_city, hash_or_array|
    #                 if state_or_city == "state"
    #                     hash_or_array.each do |state, city_array|
    #                         if !city_array.empty?
    #                             city_array.each do |city|
    #                                 Destination.create!(region: region, country: country, state: state, city: city)
    #                             end
    #                         else
    #                             Destiantion.create!(region: region, country: country, state: state)
    #                         end
    #                     end
    #                 elsif state_or_city == "city"
    #                     if !hash_or_array.empty?
    #                         hash_or_array.each do |city|
    #                             Destination.create!(region: region, country: country, city: city)
    #                         end
    #                     else
    #                         Destination.create!(region: region, country: country)
    #                     end
    #                 else
    #                     Destination.create!(region: region, country: country)
    #                 end
    #             end
    #         end
    #     end
    # end

end