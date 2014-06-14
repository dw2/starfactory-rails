class DiscussionsController < ApplicationController
  respond_to :html

  before_action :load_discussion, only: [:show, :edit, :update, :destroy]
  before_action :load_workshop, only: [:index, :show]

  add_breadcrumb 'Discussions', :discussions_url

  def index
    if @workshop.present?
      add_breadcrumb @workshop.name
      authorize @workshop, :show?
      @discussions = Discussion
        .joins(:workshop)
        .where(workshop_id: @workshop.id)
    else
      @discussions = Discussion.joins(:workshop)
    end
    @discussions = @discussions
      .order("#{sort_column} #{sort_direction}")
      .page params[:page]
    authorize @discussions
    respond_with @discussions
  end

  # GET /discussions/1
  def show
    @page_title = @discussion.name
    add_breadcrumb @discussion.workshop_name, workshop_discussions_url(@discussion.workshop)
    add_breadcrumb @discussion.name
    authorize @discussion
    @comments = @discussion.comments.by_date.page params[:page]
    respond_with @discussion
  end

  # GET /discussions/new
  def new
    @discussion = policy_scope(Discussion).new
    @discussion.student_profile_id = params[:student_profile].to_i
    @discussion.instructor_profile_id = params[:instructor_profile].to_i
    authorize @discussion

    @workshop = policy_scope(Workshop).find_by_id(params[:workshop].to_i)
    if @workshop.present?
      add_breadcrumb @workshop.name, workshop_url(@workshop)
      @discussion.workshop_id = @workshop.id
      authorize @workshop, :show?
    end

    add_breadcrumb 'New'
    respond_with @discussion
  end

  # GET /discussions/1/edit
  def edit
    add_breadcrumb @discussion.workshop_name, workshop_url(@discussion.workshop)
    add_breadcrumb 'Discussions', workshop_discussions_url(@discussion.workshop)
    add_breadcrumb @discussion.name, discussion_url(@discussion)
    add_breadcrumb 'Edit'
    authorize @discussion
    respond_with @discussion
  end

  # POST /discussions
  def create
    @discussion = policy_scope(Discussion).new(discussion_params)
    authorize @discussion
    if @discussion.save
      location = workshop_discussion_url(
        workshop_id: @discussion.workshop_id, id: @discussion)
    else
      location = @discussion
    end
    respond_with @discussion,
      location: location,
      error: 'Unable to create discussion.'
  end

  # PATCH/PUT /discussions/1
  def update
    if @discussion.update(discussion_params)
      location = workshop_discussions_url(workshop_id: @discussion.workshop_id)
      flash[:notice] = "#{@discussion.name} has been updated."
    else
      location = @discussion
    end
    respond_with @discussion,
      location: location,
      error: 'Unable to update discussion.'
  end

  # DELETE /discussions/1
  def destroy
    @discussion.destroy
    location = workshop_discussion_url(workshop_id: @discussion.workshop)
    respond_with @discussion,
      location: location,
      error: 'Unable to remove discussion.'
  end

private
  def load_discussion
    @discussion = Discussion.find(params[:id])
  end

  def load_workshop
    @workshop = Workshop.find_by_id(params[:workshop_id])
  end

  def discussion_params
    params.require(:discussion).permit(
      *policy(@discussion || Discussion).permitted_attributes
    )
  end
end
