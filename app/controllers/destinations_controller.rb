class DestinationsController < ApplicationController
    before_action :authentication_required
    
    def index
        if index_params[:search].present?
            @destinations = Destination.search(index_params[:search])
        else
            @destinations = Destination.all
        end
    end

    private

    def index_params
        params.permit(:region, :search)
    end
end