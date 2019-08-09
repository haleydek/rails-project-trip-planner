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
        
    def self.scrape_global_region
        global_regions = []
        self.get_global_region.each do |xml|
            text = xml.inner_text.strip!
            global_regions << text if text != ""
        end
        global_regions
    end

    def self.global_region_children
        global_regions_children = []
        self.scrape_global_region.each do |region|
            region = region.downcase.gsub(" ", "-").concat("-children")
            global_regions_children << region
        end
        global_regions_children
        # //*[@id="africa-children"]/div/div/div[1]/a
    end

    def self.get_country
        country_doc = []
      #  self.global_region_children.each do |children|
            self.scrape_page.xpath('//*[@id="africa-children"]/div/div/div/a/text()').each do |xml|
                country_doc << xml.inner_text
            end
      #  end
        country_doc
    end


end