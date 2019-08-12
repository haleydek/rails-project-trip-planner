class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    helper_method :current_user, :log_in, :authentication_required

    def current_user
        @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def log_in(user)
        session[:user_id] = user.id
    end

    def authentication_required
        redirect_to root_path unless session.include? :user_id
    end
end
