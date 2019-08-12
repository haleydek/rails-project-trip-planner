class Destination < ApplicationRecord
    has_many :trips_destinations
    has_many :trips, through: :trips_destinations

    validates :region, presence: true
    validates :country, presence: true
    
    # def self.filter_regions(region)
    #     where(region: region)
    # end

    # def self.unique_regions
    #     self.pluck(:region).uniq
    # end

    def self.search(search)
        where("country LIKE ? OR state LIKE ? OR city LIKE ?", search, search, search)
    end

    def self.group_by_region
        group(:region)
    end

    def self.group_by_country
        group(:country)
    end

    def format_location
        [self.country, self.state, self.city].reject{ |s| s.blank? }.join(", ")
    end

end