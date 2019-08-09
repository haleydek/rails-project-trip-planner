class TripsController < ApplicationController
    before_action :authentication_required
    before_action :find_user, only: [:new, :edit, :show]

    def new
        if @user
            @trip = Trip.new
        else
            flash[:errors] = "Cannot create a trip for an invalid user."

            redirect_to :root
        end
    end

    def create
        @user = User.find(trip_params[:user_ids].first)
        @trip = @user.trips.build(trip_params)
        if @trip.valid?
            @trip.save

            @trip.users_trips.first.update(trip_admin: true)

            redirect_to user_trip_path(@user, @trip)
        else
            render :new
        end
    end

    def edit
        #Must validate trip.users includes current_user
        #Must validate current_user is a trip_admin
        @trip = Trip.find(params[:id])
    end

    def update
        #Must validate trip.users includes current_user
        #Must validate current_user is a trip_admin
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
        @trip = Trip.find(params[:id])
        if @trip.users.include?(@user)
            render :show
        else
            flash[:errors] = "Cannot view another user's trips."

            redirect_to :root
        end
    end

    private

    def trip_params
        params.require(:trip).permit(:title, :start_date, :end_date, user_ids:[])
    end

    def find_user
        @user = User.find_by(id: params[:user_id])
    end
end
