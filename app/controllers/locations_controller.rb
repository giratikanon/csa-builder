class LocationsController < ApplicationController

  respond_to :json

  def create
    location = Cartodb.new
    location = location.create_user(params[:name])
    session[:user_id] = location.user_id
    respond_with(location)
    #  if location.valid?
    #    respond_with(location, :location => location_path(location))
    #  else
    #    respond_with(location)
    #  end
  end

  def update
    if session[:user_id]
      location = Cartodb.new(:user_id => session[:user_id])
      location = location.add_location(params[:longitude], params[:latitude])
      respond_with(location)
    else
      location = Cartodb.new
      respond_with(location) do |format|
        format.xml { render :json => {:error => "user_id must be specified when adding locations"}.to_json }
      end
    end
  end


end

