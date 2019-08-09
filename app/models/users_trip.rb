class UsersTrip < ApplicationRecord
    belongs_to :user
    belongs_to :trip

    scope :trip_admin?, -> { where(trip_admin: true) }
    scope :not_trip_admin?, -> { where(trip_admin: false) }
end
