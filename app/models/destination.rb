class Destination < ApplicationRecord
    has_many :trips_destinations
    has_many :trips, through: :trips_destinations

    validates :region, presence: true
    validates :country, presence: true

    def self.search(search)
        where("country LIKE ? OR state LIKE ? OR city LIKE ?", search, search, search)
    end

    def format_location
        [self.country, self.state, self.city].reject{ |s| s.blank? }.join(", ")
    end

    def self.most_popular
        all.max_by { |destination| destination.trips.length }
    end
end