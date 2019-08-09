class UsersController < ApplicationController
    before_action :authentication_required, only: [:show]

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.valid?
            @user.save!
            log_in user

            redirect_to :root
        else
            render :new
        end
    end

    def show
        @user = User.find(params[:id])
        @planned_trips = Trip.planned_trips(@user)
        @invited_trips = Trip.invited_trips(@user)
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password)
    end

end
