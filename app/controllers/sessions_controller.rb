class SessionsController < ApplicationController
    def new
    end

    def create
        if auth
            user = User.find_or_create_from_auth_hash(auth)
            log_in(user)

            redirect_to user_trips_path(user)
        else
            user = User.find_by(email: params[:email])
            
            # Authenticate -- check if user was found by email & if password is correct
            if user && user.authenticate(params[:password])
                log_in(user)


                redirect_to user_trips_path(user)
            else
                flash[:errors] = "Invalid email and/or password."
                
                redirect_to login_path
            end
        end
    end

    def destroy
        session.delete(:user_id)

        flash[:success] = "Successfully logged out."

        redirect_to :root
    end

    private

    def auth
        request.env['omniauth.auth']
    end

end
