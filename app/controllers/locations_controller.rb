class LocationsController < ApplicationController

  respond_to :json

  # '/locations.json'
  def create
    location = Cartodb.new
    location = location.create_user(params[:name], params[:email])
    session[:user_id] = location.user_id
    respond_to do |format|
      format.json { render :status => 200 }
    end
    #respond_with(location, :location => location_path()
    #  if location.valid?
    #    respond_with(location, :location => location_path(location))
    #  else
    #    respond_with(location)
    #  end
  end
#          format.json { render  :json   => {:error => "#{error_message}"}.to_json,
#                                :status => status_code }
  def update
    if session[:user_id] || params[:id]
      location = Cartodb.new(:user_id => session[:user_id])
      location = location.add_location(params[:longitude], params[:latitude])
      respond_with(location)
    else
      location = Cartodb.new
      respond_with(location) do |format|
        format.json { render :json => {:error => "user_id must be specified when adding locations"}.to_json }
      end
    end
  end


end

