class TripsDestination < ApplicationRecord
    belongs_to :trip
    belongs_to :destination

    validates_uniqueness_of :trip_id, scope: [:destination_id]
end