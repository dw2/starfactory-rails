class StaticController < ApplicationController
  def index
    @active_events = Event.active.limit 3
    @voted_workshops = Workshop.voted.limit 5
  end

  def contact
    add_breadcrumb 'Contact'
  end

  def status403
    add_breadcrumb 'Status 403'
  end

  def status404
    add_breadcrumb 'Status 404'
  end

  def status500
    add_breadcrumb 'Status 500'
  end
end
