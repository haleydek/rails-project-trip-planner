class Trip < ApplicationRecord
    #ensure only trip_admin can delete a trip
    has_many :users_trips, dependent: :destroy
    has_many :users, through: :users_trips
    has_many :trips_destinations, dependent: :destroy
    has_many :destinations, through: :trips_destinations

    validates :title, presence: true
    validates :start_date, presence: true
    validates :end_date, presence: true

    accepts_nested_attributes_for :users_trips, :destinations

    def self.planned_trips(user)
        self.where(id: (UsersTrip.where(user_id: user.id, trip_admin: true)).pluck(:trip_id))
    end

    def self.invited_trips(user)
        self.where(id: (UsersTrip.where(user_id: user.id, trip_admin: false)).pluck(:trip_id))
    end

    def start_date_format
        self.start_date.strftime("%a, %B #{start_date.day.ordinalize}")
    end

    def end_date_format
        self.end_date.strftime("%a, %B #{end_date.day.ordinalize}, %Y")
    end

    def current_user_is_trip_admin?(current_user)
        trip_admins = self.users.where(id: (UsersTrip.where(trip_id: self.id, trip_admin: true)).pluck(:user_id))
        trip_admins.ids.include?(current_user.id)
    end
end