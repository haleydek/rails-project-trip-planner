class Destination < ApplicationRecord
    # def self.filter_regions(region)
    #     where(region: region)
    # end

    # def self.unique_regions
    #     self.pluck(:region).uniq
    # end

    def self.search(search)
        where("country LIKE ? OR state LIKE ? OR city LIKE ?", search, search, search)
    end

end