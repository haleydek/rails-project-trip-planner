class Trip < ApplicationRecord
    #ensure only trip_admin can delete a trip
    has_many :users_trips, dependent: :destroy
    has_many :users, through: :users_trips

    validates :title, presence: true
end
