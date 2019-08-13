class UsersTripsController < ApplicationController
    def update
        users_trip = UsersTrip.find(params[:id])
        trip = Trip.find_by(id: users_trip.trip_id)

        if current_user.admin_status(trip)
            users_trip.trip_admin = !users_trip.trip_admin
            users_trip.save

            redirect_to user_trip_path(current_user, trip)
        else
            flash[:errors] = "You do not have permission to edit this trip."

            redirect_to user_trip_path(current_user, trip)
        end
    end
end