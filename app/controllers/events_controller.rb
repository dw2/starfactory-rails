class EventsController < ApplicationController
  respond_to :html

  before_action :load_event, only: [:show, :edit, :update, :destroy]

  add_breadcrumb 'Events', :events_url

  # GET /events
  def index
    @page_title = 'Events'

    if params[:year] && params[:month]
      year = params[:year].to_i
      month = params[:month].to_i
      @month = Time.parse("#{year}-#{month}-1").beginning_of_month
      add_breadcrumb @month.strftime('%B %Y')
    else
      @month = Time.now.beginning_of_month
    end

    month_start = @month.beginning_of_month
    month_end = @month.end_of_month
    @events = Event.active.where {
      ((starts_at.gte month_start) & (starts_at.lte month_end)) |
      ((ends_at.gte month_start) & (ends_at.lte month_end))
    }
    authorize @events

    # Redirect to next month if there are no events this month, but are some next month
    if @events.size == 0
      next_month = @month + 1.month
      month_start = next_month.beginning_of_month
      month_end = next_month.end_of_month
      next_month_events = Event.active.where {
        ((starts_at.gte month_start) & (starts_at.lte month_end)) |
        ((ends_at.gte month_start) & (ends_at.lte month_end))
      }
      if next_month_events.size > 0
        redirect_to events_month_url(next_month.year, next_month.month), status: 302
        return
      end
    end

    @events_by_day = {}
    (1..@month.end_of_month.day).each{|d| @events_by_day[d] = [] }
    @events.each do |event|
      @events_by_day[event.starts_at.day].push event
    end

    respond_with @events
  end

  # GET /events/1
  def show
    @page_title = @event.workshop_name
    add_breadcrumb @event.workshop_name
    authorize @event
    respond_with @events
  end

  # GET /events/new
  def new
    @event = policy_scope(Event).new
    add_breadcrumb 'New'
    authorize @event
    @event.workshop_id = params[:workshop].to_i
    respond_with @event
  end

  # GET /events/1/edit
  def edit
    add_breadcrumb @event.workshop_name, event_url(@event)
    add_breadcrumb 'Edit'
    authorize @event
    respond_with @event
  end

  # POST /events
  def create
    @event = policy_scope(Event).new(event_params)
    authorize @event
    @event.save
    respond_with @event, location: @event, error: 'Unable to add event.'
  end

  # PATCH/PUT /events/1
  def update
    @event.update(event_params)
    respond_with @event, location: @event, error: 'Unable to add event.'
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    respond_with @event, location: @event, error: 'Unable to remove event.'
  end

private
  def load_event
    @event = policy_scope(Event).find(params[:id])
  end

  def event_params
    zone = '-07:00'
    if params[:event][:starts_at].blank? && params[:event][:starts_at_day].present?
      params[:event][:starts_at] = DateTime.strptime(
        "#{params[:event][:starts_at_day]}T#{params[:event][:starts_at_time]}:00#{zone}")
    end
    if params[:event][:ends_at].blank? && params[:event][:ends_at_day].present?
      params[:event][:ends_at] = DateTime.strptime(
        "#{params[:event][:ends_at_day]}T#{params[:event][:ends_at_time]}:00#{zone}")
    end
    params.require(:event).permit(
      *policy(@event || Event).permitted_attributes
    )
  end
end
