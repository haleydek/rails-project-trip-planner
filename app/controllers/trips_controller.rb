class TripsController < ApplicationController
    before_action :authentication_required
    before_action :find_user, only: [:new, :edit, :update, :show, :index]
    before_action :find_trip, only: [:edit, :update, :show, :destroy]

    def new
        if @user
            @trip = @user.trips.build
        else
            flash[:errors] = "Cannot create a trip for an invalid user."

            redirect_to user_trips_path(current_user)
        end
    end

    def create
        # The first user id in :user_ids array will be the current_user/trip creator
        @user = User.find(trip_params[:user_ids].first)

        # Set up association between user and a new trip
        @trip = @user.trips.build(trip_params)
        
        if @trip.valid?
            @trip.save

            # The first users_trip record that belongs to the new trip will also belong to
            #   the current_user/trip creator.
            #   Trip creator must be set as a trip_admin.
            @trip.users_trips.first.update(trip_admin: true)

            # Set up association between the selected destinations and the new trip.
            @trip.destination_ids=(trip_params[:destination_ids])

            redirect_to user_trip_path(@user, @trip)
        else
            render :new
        end
    end

    def edit
        # Current_user must be a trip_admin to edit the trip.
        if @trip.current_user_is_trip_admin?(@user)
            render :edit
        else
            flash[:errors] = "You do not have permission to edit this trip."

            redirect_to user_trip_path(@user, @trip)
        end
    end

    def update
        if @trip.update(trip_params)
            # @trip.update does not change trip_admin value in users_trips table
            redirect_to user_trip_path(current_user, @trip)
        else
            render :edit
        end
    end

    def destroy
        # Current_user must be a trip_admin to delete the trip.
        if current_user.admin_status(@trip)
            @trip.destroy

            flash[:success] = "Trip was successfully deleted."

            redirect_to user_trips_path(current_user)
        else
            flash[:errors] = "You do not have permissin to delete this trip."

            redirect_to user_trip_path(current_user, @trip)
        end
    end

    def index
        @planned_trips = @user.planned_trips
        @invited_trips = @user.invited_trips
    end

    def show
        # Only users associated with the trip can view the trip.
        if @trip.users.include?(@user)
            render :show
        else
            flash[:errors] = "Cannot view another user's trips."

            redirect_to user_trips_path(@user)
        end
    end

    private

    def trip_params
        params.require(:trip).permit(:title, :start_date, :end_date, user_ids:[], destination_ids: [])
    end

    def find_user
        @user = User.find_by(id: params[:user_id])
    end

    def find_trip
        @trip = Trip.find_by(id: params[:id])
    end
end
