class LocationsController < ApplicationController
  respond_to :html

  before_action :load_location, only: [:show, :edit, :update, :destroy]

  # GET /locations/1
  def show
    @page_title = @location.name
    add_breadcrumb @location.name
    authorize @location
    respond_with @location
  end

  # GET /locations/new
  def new
    @location = policy_scope(Location).new
    add_breadcrumb 'Locations', :admin_locations_url
    add_breadcrumb 'New'
    authorize @location
    respond_with @location
  end

  # GET /locations/1/edit
  def edit
    add_breadcrumb 'Locations', :admin_locations_url
    add_breadcrumb @location.name, location_url(@location)
    add_breadcrumb 'Edit'
    authorize @location
    respond_with @location
  end

  # POST /locations
  def create
    add_breadcrumb 'Locations', :admin_locations_url
    add_breadcrumb 'New'
    @location = policy_scope(Location).new(location_params)
    authorize @location
    if @location.save
      location = admin_locations_url
    else
      location = @location
    end
    respond_with @location,
      location: location,
      error: 'Unable to add location.'
  end

  # PATCH/PUT /locations/1
  def update
    add_breadcrumb 'Locations', :admin_locations_url
    add_breadcrumb @location.name, location_url(@location)
    add_breadcrumb 'Edit'
    authorize @location
    if @location.update(location_params)
      location = admin_locations_url
    else
      location = @location
    end
    respond_with @location,
      location: location,
      error: 'Unable to update location.'
  end

  # DELETE /locations/1
  def destroy
    add_breadcrumb 'Locations', :admin_locations_url
    add_breadcrumb @location.name, location_url(@location)
    authorize @location
    if @location.destroy
      flash[:notice] = "#{@location.name} has been deleted."
    end
    add_breadcrumb 'Locations', :admin_locations_url
    respond_with @location,
      location: admin_locations_url,
      error: 'Unable to remove location.'
  end

private
  def load_location
    @location = policy_scope(Location).find(params[:id])
  end

  def location_params
    params.require(:location).permit(
      *policy(@location || Location).permitted_attributes
    )
  end
end
