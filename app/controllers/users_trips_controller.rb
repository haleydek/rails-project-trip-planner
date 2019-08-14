class UsersTripsController < ApplicationController
    before_action :authentication_required

    # link on trip#show page routes to this action
    def update
        users_trip = UsersTrip.find(params[:id])
        trip = Trip.find_by(id: users_trip.trip_id)

        # check if current user is an admin for the trip
        if current_user.admin_status(trip)
            # change :trip_admin boolean value to the opposite of its current value
            users_trip.trip_admin = !users_trip.trip_admin
            users_trip.save

            redirect_to user_trip_path(current_user, trip)
        else
            flash[:errors] = "You do not have permission to edit this trip."

            redirect_to user_trip_path(current_user, trip)
        end
    end
end