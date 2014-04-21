class WorkshopsController < ApplicationController
  respond_to :html

  before_action :set_workshop, only: [:show, :edit, :update, :destroy]

  add_breadcrumb 'Workshops', :workshops_url

  # GET /workshops
  def index
    @workshops = Workshop.active
    authorize @workshops
    respond_with @workshops
  end

  # GET /workshops/1
  def show
    add_breadcrumb @workshop.name
    authorize @workshop
    respond_with @workshop
  end

  # GET /workshops/new
  def new
    add_breadcrumb 'New'
    @workshop = policy_scope(Workshop).new
    authorize @workshop
    respond_with @workshop
  end

  # GET /workshops/1/edit
  def edit
    add_breadcrumb @workshop.name, workshop_url(@workshop)
    add_breadcrumb 'Edit'
    authorize @workshop
    respond_with @workshop
  end

  # POST /workshops
  def create
    @workshop = policy_scope(Workshop).new(workshop_params)
    authorize @workshop
    @workshop.save
    respond_with @workshop, location: @workshop, error: 'Unable to add workshop.'
  end

  # PATCH/PUT /workshops/1
  def update
    authorize @workshop
    @workshop.update(workshop_params)
    respond_with @workshop, location: @workshop, error: 'Unable to add workshop.'
  end

  # DELETE /workshops/1
  def destroy
    authorize @workshop
    @workshop.destroy
    respond_with @workshop, location: @workshop, error: 'Unable to remove workshop.'
  end

private
  def set_workshop
    @workshop = Workshop.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(
      *policy(@workshop || Workshop).permitted_attributes
    )
  end
end
