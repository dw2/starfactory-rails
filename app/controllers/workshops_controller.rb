class WorkshopsController < ApplicationController
  respond_to :html

  before_action :load_workshop, only: [:show, :edit, :update, :destroy, :clear_votes]
  before_action :load_current_user_vote, only: [:show]

  add_breadcrumb 'Tracks', :tracks_url

  def index
    redirect_to tracks_url
  end

  # GET /workshops/1
  def show
    @page_title = @workshop.name
    add_breadcrumb @workshop.track_name, track_url(@workshop.track)
    add_breadcrumb @workshop.name
    authorize @workshop
    @workshop_data = @workshop.slice :id, :name
    respond_with @workshop
  end

  # GET /workshops/new
  def new
    @workshop = policy_scope(Workshop).new
    add_breadcrumb 'New'
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
    respond_with @workshop,
      location: @workshop,
      error: 'Unable to add workshop.'
  end

  # PATCH/PUT /workshops/1
  def update
    @workshop.update(workshop_params)
    respond_with @workshop,
      location: @workshop,
      error: 'Unable to save workshop.'
  end

  # DELETE /workshops/1
  def destroy
    if @workshop.destroy
      flash[:notice] = "#{@workshop.name} has been deleted."
    end
    respond_with @workshop,
      location: admin_workshops_url,
      error: 'Unable to remove workshop.'
  end

  # PATCH/PUT /workshops/1/clear_votes
  def clear_votes
    authorize @workshop
    if @workshop.votes.delete_all
      @workshop.reload
      @workshop.votes_count = 0
      @workshop.save
    end
    respond_with @workshop
  end

private
  def load_workshop
    @workshop = policy_scope(Workshop).find(params[:id])
  end

  def load_current_user_vote
    if logged_in?
      @vote = @workshop.votes.find_by_user_id current_user.id
    else
      @vote = nil
    end
  end

  def workshop_params
    params.require(:workshop).permit(
      *policy(@workshop || Workshop).permitted_attributes
    )
  end
end
