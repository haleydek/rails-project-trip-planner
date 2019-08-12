class UsersTrip < ApplicationRecord
    belongs_to :user
    belongs_to :trip

    validates_uniqueness_of :trip_id, scope: [:user_id]

    scope :trip_admin?, -> { where(trip_admin: true) }
    scope :not_trip_admin?, -> { where(trip_admin: false) }
end
