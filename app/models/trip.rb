class Trip < ApplicationRecord
    #ensure only trip_admin can delete a trip
    has_many :users_trips, dependent: :destroy
    has_many :users, through: :users_trips

    validates :title, presence: true

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

    def current_user_is_trip_admin?(user)
        trip_admins = self.users.where(id: (UsersTrip.where(trip_id: self.id, trip_admin: true)).pluck(:user_id))
        trip_admins.ids.include?(user.id)
    end
end