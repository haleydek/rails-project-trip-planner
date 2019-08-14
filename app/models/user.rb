class User < ApplicationRecord
    has_many :users_trips
    has_many :trips, through: :users_trips

    validates :name, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /@/ }

    has_secure_password

    scope :all_except, -> (user) { where.not(id: user.id) }

    def self.find_or_create_from_auth_hash(auth)
        # find the first record with a matching uid and update it via #tap
        # OR if no matching record exists, create a new one.
        where(uid: auth.uid).first_or_initialize.tap do |user|
            user.uid = auth.uid
            user.name = auth.info.name
            user.email = auth.info.email
            user.image = auth.info.image
            user.password = SecureRandom.urlsafe_base64
            user.save!
        end
    end

    def admin_status(trip)
        self.users_trips.where(user_id: self.id, trip_id: trip.id).first.trip_admin
    end

    def update_user_trip_admin(current_user, trip)
        current_user_admin_status = current_user.admin_status(trip)
        if !!current_user_admin_status
            self.users_trips.where(user_id: self.id, trip_id: trip.id).first.update_attribute :trip_admin, !self.admin_status(trip)
        end
    end

    def planned_trips
        self.trips.where(id: (UsersTrip.where(user_id: self.id, trip_admin: true)).pluck(:trip_id))
    end

    def invited_trips
        self.trips.where(id: (UsersTrip.where(user_id: self.id, trip_admin: false)).pluck(:trip_id))
    end

end