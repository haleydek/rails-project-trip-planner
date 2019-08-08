class TripsController < ApplicationController
    def new
        @trip = Trip.new
    end

    def create
        @trip = Trip.new(trip_params)
        if @trip.valid?
            @trip.save!

            redirect_to trip_path(@trip)
        else
            render :new
        end
    end

    def edit
        #Must validate trip.users includes current_user
        #Must validate current_user is a trip_planner
        @trip = Trip.find(params[:id])
    end

    def update
        #Must validate trip.users includes current_user
        #Must validate current_user is a trip_planner
        @trip = Trip.find(params[:id])
        if @trip.update
            redirect_to trip_path(@trip)
        else
            render :edit
        end
    end

    def destroy
    end

    def index
    end

    def show
    end

    private

    def trip_params
        params.require(:trip).permit(:title, :start_date, :end_date)
    end
end
