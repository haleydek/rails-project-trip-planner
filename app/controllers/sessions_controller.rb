class SessionsController < ApplicationController
    def new
    end

    def create
        if auth
            @user = User.find_or_create_from_auth_hash(auth)
            session[:user_id] = @user.id

            redirect_to :root
        else
            user = User.find(params[:user][:email])
            
            if user && user.authenticate(params[:password])
                log_in(user)


                redirect_to :root
            else
                flash[:notice] = "Invalid email and/or password"
                
                redirect_to login_path
            end
        end
    end

    def destroy
        session.delete(:user_id)

        redirect_to :root
    end

    private

    def auth
        request.env['omniauth.auth']
    end

end
