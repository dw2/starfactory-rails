class AdminController < ApplicationController
  respond_to :html
  add_breadcrumb 'Admin', :admin_url

  def index
  end

  def discussions
    add_breadcrumb 'Discussions'
    @workshop = Workshop.find_by_id(params[:workshop].to_i)
    if @workshop.present?
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

  def events
    add_breadcrumb 'Events'
    @events = Event
      .joins(:workshop)
      .order("#{sort_column} #{sort_direction}")
      .page params[:page]
    authorize @events
    respond_with @events
  end

  def instructor_profiles
    add_breadcrumb 'Instructors'
    @instructor_profiles = InstructorProfile
      .joins(:user)
      .order("#{sort_column} #{sort_direction}")
      .page params[:page]
    authorize @instructor_profiles
    respond_with @instructor_profiles
  end

  def locations
    add_breadcrumb 'Locations'
    @locations = Location
      .order("#{sort_column} #{sort_direction}")
      .page params[:page]
    authorize @locations
    respond_with @locations
  end

  def registrations
    @event = Event.find_by_id params[:event_id]
    @registrations = Registration
      .joins(:student_profile)
      .joins(:event)
      .where(event_id: @event.id)
      .order("#{sort_column} #{sort_direction}")
      .page params[:page]
    authorize @registrations
    add_breadcrumb 'Events', admin_events_url
    add_breadcrumb @event.workshop_name, event_url(@event)
    add_breadcrumb 'Registrations'
    respond_with @registrations
  end

  def student_profiles
    add_breadcrumb 'Students'
    @student_profiles = StudentProfile
      .joins(:user)
      .order("#{sort_column} #{sort_direction}")
      .page params[:page]
    authorize @student_profiles
    respond_with @student_profiles
  end

  def tracks
    add_breadcrumb 'Tracks'
    @tracks = Track
      .order("#{sort_column} #{sort_direction}")
      .page params[:page]
    authorize @tracks
    respond_with @tracks
  end

  def users
    add_breadcrumb 'Users'
    @users = User
      .order("#{sort_column} #{sort_direction}")
      .page params[:page]
    authorize @users
    respond_with @users
  end

  def workshops
    @workshops = Workshop.joins(:track)
    if !!params[:id]
      @track = policy_scope(Track).find_by_id params[:id]
      if @track.present?
        @workshops = @workshops.where(track_id: @track)
        add_breadcrumb 'Tracks', admin_tracks_url
        add_breadcrumb "#{@workshops.first.track_name} Workshops"
      else
        add_breadcrumb 'Workshops'
      end
    else
      add_breadcrumb 'Workshops'
    end
    @workshops = @workshops
      .order("#{sort_column} #{sort_direction}")
      .page params[:page]
    authorize @workshops
    respond_with @workshops
  end
end
