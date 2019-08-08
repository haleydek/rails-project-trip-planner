class TripsController < ApplicationController
    def new
        if params[:user_id].to_i == session[:user_id] && User.exists?(params[:user_id])
            @trip = Trip.new
        else
            flash[:errors] = "Cannot create a trip for an invalid user."

            redirect_to :root
        end
    end

    def create
        @trip = current_user.trips.build(trip_params)
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
        params.require(:trip).permit(:title, :start_date, :end_date, :user_id)
    end
end
