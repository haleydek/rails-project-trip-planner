class TripsController < ApplicationController
    before_action :authentication_required
    before_action :find_user, only: [:new, :edit, :show, :index]
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
        @user = User.find(trip_params[:user_ids].first)
        @trip = @user.trips.build(trip_params)
        
        if @trip.valid?
            @trip.save

            @trip.users_trips.first.update(trip_admin: true)

            @trip.destination_ids=(trip_params[:destination_ids])

            redirect_to user_trip_path(@user, @trip)
        else
            render :new
        end
    end

    def edit
        if @trip.current_user_is_trip_admin?(@user)
            render :edit
        else
            flash[:errors] = "You do not have permission to edit this trip."

            redirect_to user_trip_path(@user, @trip)
        end
    end

    def update
        #update does not change trip_admin value in users_trips table
        if @trip.update(trip_params)
            redirect_to user_trip_path(current_user, @trip)
        else
            render :edit
        end
    end

    def destroy
        if @trip.current_user_is_trip_admin?(@user)
            @trip.destroy

            flash[:notice] = "Trip was successfully deleted."

            redirect_to user_trips_path(@user)
        else
            flash[:errors] = "You do not have permissin to delete this trip."

            redirect_to user_trip_path(@user, @trip)
        end
    end

    def index
        @planned_trips = Trip.planned_trips(@user)
        @invited_trips = Trip.invited_trips(@user)
    end

    def show
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
