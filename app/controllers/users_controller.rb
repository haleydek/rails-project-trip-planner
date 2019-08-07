class UsersController < ApplicationController
    before_action :authentication_required, only: [:show]

    def new
        @user = User.new
    end

    def create
        user = User.new(user_params)
        if user.save!
            log_in user

            redirect_to :root
        else
            #flash errors in view
            redirect_to signup_path
        end
    end

    def show
        @user = User.find(params[:id])
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password)
    end

end
