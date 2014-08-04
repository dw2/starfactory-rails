class DiscussionsController < ApplicationController
  respond_to :html

  before_action :load_discussion, only: [:show, :edit, :update, :destroy]
  before_action :load_track, only: [:index, :show]
  before_action :load_workshop, only: [:index, :show]

  add_breadcrumb 'Forum', :forum_url

  def index
    case
    when @workshop.present?
      add_breadcrumb @workshop.track_name, track_discussions_url(track_id: @workshop.track)
      add_breadcrumb @workshop.name
      authorize @workshop, :show?
      @discussions = Discussion
        .joins(:workshop)
        .where(workshop_id: @workshop.id)
    when @track.present?
      add_breadcrumb @track.name
      authorize @track, :show?
      workshop_ids = @track.workshops.active.pluck :id
      @discussions = Discussion
        .joins(:workshop)
        .where{ workshop_id.in workshop_ids }
    else
      @discussions = Discussion.joins(:workshop)
    end
    @discussions = @discussions
      .order("#{sort_column} #{sort_direction}")
      .page params[:page]
    authorize @discussions
    respond_with @discussions
  end

  def forum
    raise NotAuthorizedError unless logged_in?
    @tracks = Track.active.by_name
  end

  # GET /discussions/1
  def show
    @page_title = @discussion.name
    add_breadcrumb @discussion.workshop.track_name, track_discussions_url(track_id: @discussion.workshop.track)
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

    case
    when !!params[:track]
      @track = policy_scope(Track).find_by_id(params[:track].to_i)
      if @track.present?
        add_breadcrumb @track.name, track_discussions_url(track_id: @track)
        authorize @track, :show?
        @workshops_collection_for_select =
          @track.workshops.active.by_sort.map {|w| [w.name, w.id]}
      end

    when !!params[:workshop]
      @workshop = policy_scope(Workshop).find_by_id(params[:workshop].to_i)
      if @workshop.present?
        add_breadcrumb @workshop.name, workshop_discussions_url(workshop_id: @workshop)
        @discussion.workshop_id = @workshop.id
        authorize @workshop, :show?
      end
    end

    unless @workshop.present? || @workshops_collection_for_select.present?
      @workshops_collection_for_select = Track.active.map{|t|
        [t.name, t.workshops.active.by_sort.map {|w| [w.name, w.id]}]}
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
    @discussion.update(discussion_params)
    respond_with @discussion,
      location: workshop_discussions_url(workshop_id: @discussion.workshop),
      error: 'Unable to save discussion.'
  end

  # DELETE /discussions/1
  def destroy
    if @discussion.destroy
      flash[:notice] = "#{@discussion.name} has been deleted."
    end
    respond_with @discussion,
      location: workshop_discussions_url(workshop_id: @discussion.workshop),
      error: 'Unable to remove discussion.'
  end

private
  def load_discussion
    @discussion = policy_scope(Discussion).find(params[:id])
  end

  def load_track
    @track = policy_scope(Track).find_by_id(params[:track_id])
  end

  def load_workshop
    @workshop = policy_scope(Workshop).find_by_id(params[:workshop_id])
  end

  def discussion_params
    params.require(:discussion).permit(
      *policy(@discussion || Discussion).permitted_attributes
    )
  end
end
